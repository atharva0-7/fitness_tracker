from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.models.workout import Workout, Exercise, WorkoutSession, WorkoutPlan, WorkoutDay
from app.models.user import User
from app.services.ai_service import AIService
from app import db
from datetime import datetime
import uuid
import json

workout_bp = Blueprint('workout', __name__)
ai_service = AIService()

@workout_bp.route('/generate', methods=['POST'])
@jwt_required()
def generate_workout_plan():
    """Generate AI-powered workout plan"""
    try:
        user_id = get_jwt_identity()
        user = User.query.get(user_id)
        
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        data = request.get_json()
        
        # Prepare user data for AI
        user_data = {
            'fitness_goal': data.get('goal', 'general_fitness'),
            'difficulty': data.get('difficulty', 'beginner'),
            'duration': data.get('duration', 30),
            'equipment': data.get('equipment', []),
            'body_parts': data.get('body_parts', []),
            'days_per_week': data.get('days_per_week', 3),
            'current_weight': user.weight,
            'height': user.height,
            'age': user.age,
            'activity_level': user.activity_level
        }
        
        # Generate workout plan using AI
        ai_plan = ai_service.generate_workout_plan(user_data)
        
        # Create workout plan in database
        workout_plan = WorkoutPlan(
            id=str(uuid.uuid4()),
            name=ai_plan.get('plan_name', 'AI Generated Workout Plan'),
            description=ai_plan.get('description', ''),
            user_id=user_id,
            total_weeks=ai_plan.get('total_weeks', 4),
            difficulty=ai_plan.get('difficulty', 'beginner'),
            created_at=datetime.utcnow(),
            is_active=True
        )
        
        db.session.add(workout_plan)
        db.session.flush()  # Get the ID
        
        # Create workout days
        for week_data in ai_plan.get('weeks', []):
            for day_data in week_data.get('days', []):
                workout_day = WorkoutDay(
                    id=str(uuid.uuid4()),
                    plan_id=workout_plan.id,
                    day_number=day_data.get('day_number', 1),
                    name=day_data.get('day_name', 'Workout Day'),
                    is_rest_day=day_data.get('workout_type', '').lower() == 'rest',
                    notes=json.dumps(day_data.get('exercises', [])),
                    created_at=datetime.utcnow()
                )
                db.session.add(workout_day)
        
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Workout plan generated successfully',
            'data': {
                'plan_id': workout_plan.id,
                'plan_name': workout_plan.name,
                'description': workout_plan.description,
                'total_weeks': workout_plan.total_weeks,
                'difficulty': workout_plan.difficulty,
                'ai_plan': ai_plan
            }
        }), 201
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@workout_bp.route('/', methods=['GET'])
@jwt_required()
def get_workouts():
    """Get user's workout plans"""
    try:
        user_id = get_jwt_identity()
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 10, type=int)
        
        workouts = WorkoutPlan.query.filter_by(user_id=user_id)\
            .order_by(WorkoutPlan.created_at.desc())\
            .paginate(page=page, per_page=per_page, error_out=False)
        
        workout_list = []
        for workout in workouts.items:
            workout_list.append({
                'id': workout.id,
                'name': workout.name,
                'description': workout.description,
                'total_weeks': workout.total_weeks,
                'difficulty': workout.difficulty,
                'is_active': workout.is_active,
                'created_at': workout.created_at.isoformat()
            })
        
        return jsonify({
            'success': True,
            'data': {
                'workouts': workout_list,
                'pagination': {
                    'page': page,
                    'per_page': per_page,
                    'total': workouts.total,
                    'pages': workouts.pages,
                    'has_next': workouts.has_next,
                    'has_prev': workouts.has_prev
                }
            }
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@workout_bp.route('/<workout_id>', methods=['GET'])
@jwt_required()
def get_workout(workout_id):
    """Get specific workout plan"""
    try:
        user_id = get_jwt_identity()
        workout = WorkoutPlan.query.filter_by(id=workout_id, user_id=user_id).first()
        
        if not workout:
            return jsonify({'error': 'Workout not found'}), 404
        
        # Get workout days
        days = WorkoutDay.query.filter_by(plan_id=workout_id).order_by(WorkoutDay.day_number).all()
        
        days_data = []
        for day in days:
            days_data.append({
                'id': day.id,
                'day_number': day.day_number,
                'name': day.name,
                'is_rest_day': day.is_rest_day,
                'notes': json.loads(day.notes) if day.notes else [],
                'created_at': day.created_at.isoformat()
            })
        
        return jsonify({
            'success': True,
            'data': {
                'id': workout.id,
                'name': workout.name,
                'description': workout.description,
                'total_weeks': workout.total_weeks,
                'difficulty': workout.difficulty,
                'is_active': workout.is_active,
                'created_at': workout.created_at.isoformat(),
                'days': days_data
            }
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@workout_bp.route('/<workout_id>/complete', methods=['POST'])
@jwt_required()
def complete_workout(workout_id):
    """Complete a workout session"""
    try:
        user_id = get_jwt_identity()
        data = request.get_json()
        
        # Create workout session
        session = WorkoutSession(
            id=str(uuid.uuid4()),
            workout_id=workout_id,
            user_id=user_id,
            start_time=datetime.fromisoformat(data.get('start_time', datetime.utcnow().isoformat())),
            end_time=datetime.fromisoformat(data.get('end_time', datetime.utcnow().isoformat())),
            duration=data.get('duration', 0),
            calories_burned=data.get('calories_burned', 0),
            notes=data.get('notes', ''),
            status='completed',
            created_at=datetime.utcnow()
        )
        
        db.session.add(session)
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Workout completed successfully',
            'data': {
                'session_id': session.id,
                'workout_id': workout_id,
                'duration': session.duration,
                'calories_burned': session.calories_burned,
                'completed_at': session.end_time.isoformat()
            }
        }), 201
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@workout_bp.route('/sessions', methods=['GET'])
@jwt_required()
def get_workout_sessions():
    """Get user's workout sessions"""
    try:
        user_id = get_jwt_identity()
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 10, type=int)
        
        sessions = WorkoutSession.query.filter_by(user_id=user_id)\
            .order_by(WorkoutSession.created_at.desc())\
            .paginate(page=page, per_page=per_page, error_out=False)
        
        session_list = []
        for session in sessions.items:
            session_list.append({
                'id': session.id,
                'workout_id': session.workout_id,
                'start_time': session.start_time.isoformat(),
                'end_time': session.end_time.isoformat(),
                'duration': session.duration,
                'calories_burned': session.calories_burned,
                'status': session.status,
                'notes': session.notes,
                'created_at': session.created_at.isoformat()
            })
        
        return jsonify({
            'success': True,
            'data': {
                'sessions': session_list,
                'pagination': {
                    'page': page,
                    'per_page': per_page,
                    'total': sessions.total,
                    'pages': sessions.pages,
                    'has_next': sessions.has_next,
                    'has_prev': sessions.has_prev
                }
            }
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500