from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.models.meal import Meal, MealPlan, NutritionLog
from app.models.user import User
from app.services.ai_service import AIService
from app import db
from datetime import datetime, date
import uuid
import json

meal_bp = Blueprint('meal', __name__)
ai_service = AIService()

@meal_bp.route('/generate', methods=['POST'])
@jwt_required()
def generate_meal_plan():
    """Generate AI-powered meal plan"""
    try:
        user_id = get_jwt_identity()
        user = User.query.get(user_id)
        
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        data = request.get_json()
        
        # Prepare user data for AI
        user_data = {
            'target_calories': data.get('calorie_target', 2000),
            'dietary_preference': data.get('dietary_preferences', ['balanced']),
            'allergies': data.get('allergies', []),
            'meal_types': data.get('meals_per_day', 3),
            'days': data.get('days', 7),
            'cooking_time': data.get('cooking_time', '30 minutes'),
            'cooking_skill': data.get('skill_level', 'beginner'),
            'current_weight': user.weight,
            'height': user.height,
            'age': user.age,
            'activity_level': user.activity_level
        }
        
        # Generate meal plan using AI
        ai_plan = ai_service.generate_meal_plan(user_data)
        
        # Create meal plan in database
        meal_plan = MealPlan(
            id=str(uuid.uuid4()),
            name=ai_plan.get('plan_name', 'AI Generated Meal Plan'),
            description=ai_plan.get('description', ''),
            user_id=user_id,
            target_calories=ai_plan.get('target_calories', 2000),
            dietary_preference=ai_plan.get('dietary_preference', 'balanced'),
            total_days=len(ai_plan.get('days', [])),
            created_at=datetime.utcnow(),
            is_active=True
        )
        
        db.session.add(meal_plan)
        db.session.flush()  # Get the ID
        
        # Create meals for each day
        for day_data in ai_plan.get('days', []):
            for meal_data in day_data.get('meals', []):
                meal = Meal(
                    id=str(uuid.uuid4()),
                    plan_id=meal_plan.id,
                    day_number=day_data.get('day_number', 1),
                    meal_type=meal_data.get('meal_type', 'breakfast'),
                    name=meal_data.get('name', ''),
                    calories=meal_data.get('calories', 0),
                    protein=meal_data.get('protein', 0),
                    carbs=meal_data.get('carbs', 0),
                    fat=meal_data.get('fat', 0),
                    ingredients=json.dumps(meal_data.get('ingredients', [])),
                    instructions=json.dumps(meal_data.get('instructions', [])),
                    prep_time=meal_data.get('prep_time', 0),
                    cook_time=meal_data.get('cook_time', 0),
                    created_at=datetime.utcnow()
                )
                db.session.add(meal)
        
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Meal plan generated successfully',
            'data': {
                'plan_id': meal_plan.id,
                'plan_name': meal_plan.name,
                'description': meal_plan.description,
                'target_calories': meal_plan.target_calories,
                'dietary_preference': meal_plan.dietary_preference,
                'total_days': meal_plan.total_days,
                'ai_plan': ai_plan
            }
        }), 201
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@meal_bp.route('/', methods=['GET'])
@jwt_required()
def get_meal_plans():
    """Get user's meal plans"""
    try:
        user_id = get_jwt_identity()
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 10, type=int)
        
        meal_plans = MealPlan.query.filter_by(user_id=user_id)\
            .order_by(MealPlan.created_at.desc())\
            .paginate(page=page, per_page=per_page, error_out=False)
        
        plan_list = []
        for plan in meal_plans.items:
            plan_list.append({
                'id': plan.id,
                'name': plan.name,
                'description': plan.description,
                'target_calories': plan.target_calories,
                'dietary_preference': plan.dietary_preference,
                'total_days': plan.total_days,
                'is_active': plan.is_active,
                'created_at': plan.created_at.isoformat()
            })
        
        return jsonify({
            'success': True,
            'data': {
                'meal_plans': plan_list,
                'pagination': {
                    'page': page,
                    'per_page': per_page,
                    'total': meal_plans.total,
                    'pages': meal_plans.pages,
                    'has_next': meal_plans.has_next,
                    'has_prev': meal_plans.has_prev
                }
            }
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@meal_bp.route('/<plan_id>', methods=['GET'])
@jwt_required()
def get_meal_plan(plan_id):
    """Get specific meal plan"""
    try:
        user_id = get_jwt_identity()
        plan = MealPlan.query.filter_by(id=plan_id, user_id=user_id).first()
        
        if not plan:
            return jsonify({'error': 'Meal plan not found'}), 404
        
        # Get meals for this plan
        meals = Meal.query.filter_by(plan_id=plan_id).order_by(Meal.day_number, Meal.meal_type).all()
        
        meals_data = []
        for meal in meals:
            meals_data.append({
                'id': meal.id,
                'day_number': meal.day_number,
                'meal_type': meal.meal_type,
                'name': meal.name,
                'calories': meal.calories,
                'protein': meal.protein,
                'carbs': meal.carbs,
                'fat': meal.fat,
                'ingredients': json.loads(meal.ingredients) if meal.ingredients else [],
                'instructions': json.loads(meal.instructions) if meal.instructions else [],
                'prep_time': meal.prep_time,
                'cook_time': meal.cook_time,
                'created_at': meal.created_at.isoformat()
            })
        
        return jsonify({
            'success': True,
            'data': {
                'id': plan.id,
                'name': plan.name,
                'description': plan.description,
                'target_calories': plan.target_calories,
                'dietary_preference': plan.dietary_preference,
                'total_days': plan.total_days,
                'is_active': plan.is_active,
                'created_at': plan.created_at.isoformat(),
                'meals': meals_data
            }
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@meal_bp.route('/<meal_id>/log', methods=['POST'])
@jwt_required()
def log_meal(meal_id):
    """Log a meal consumption"""
    try:
        user_id = get_jwt_identity()
        data = request.get_json()
        
        # Get the meal
        meal = Meal.query.get(meal_id)
        if not meal:
            return jsonify({'error': 'Meal not found'}), 404
        
        # Create nutrition log entry
        nutrition_log = NutritionLog(
            id=str(uuid.uuid4()),
            user_id=user_id,
            meal_id=meal_id,
            consumed_at=datetime.fromisoformat(data.get('consumed_at', datetime.utcnow().isoformat())),
            serving_size=data.get('serving_size', 1.0),
            calories=meal.calories * data.get('serving_size', 1.0),
            protein=meal.protein * data.get('serving_size', 1.0),
            carbs=meal.carbs * data.get('serving_size', 1.0),
            fat=meal.fat * data.get('serving_size', 1.0),
            notes=data.get('notes', ''),
            created_at=datetime.utcnow()
        )
        
        db.session.add(nutrition_log)
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Meal logged successfully',
            'data': {
                'log_id': nutrition_log.id,
                'meal_id': meal_id,
                'calories': nutrition_log.calories,
                'protein': nutrition_log.protein,
                'carbs': nutrition_log.carbs,
                'fat': nutrition_log.fat,
                'consumed_at': nutrition_log.consumed_at.isoformat()
            }
        }), 201
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@meal_bp.route('/logs', methods=['GET'])
@jwt_required()
def get_nutrition_logs():
    """Get user's nutrition logs"""
    try:
        user_id = get_jwt_identity()
        date_filter = request.args.get('date')
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 10, type=int)
        
        query = NutritionLog.query.filter_by(user_id=user_id)
        
        if date_filter:
            filter_date = datetime.fromisoformat(date_filter).date()
            query = query.filter(NutritionLog.consumed_at >= filter_date)\
                        .filter(NutritionLog.consumed_at < filter_date.replace(day=filter_date.day + 1))
        
        logs = query.order_by(NutritionLog.consumed_at.desc())\
            .paginate(page=page, per_page=per_page, error_out=False)
        
        log_list = []
        for log in logs.items:
            log_list.append({
                'id': log.id,
                'meal_id': log.meal_id,
                'consumed_at': log.consumed_at.isoformat(),
                'serving_size': log.serving_size,
                'calories': log.calories,
                'protein': log.protein,
                'carbs': log.carbs,
                'fat': log.fat,
                'notes': log.notes,
                'created_at': log.created_at.isoformat()
            })
        
        return jsonify({
            'success': True,
            'data': {
                'logs': log_list,
                'pagination': {
                    'page': page,
                    'per_page': per_page,
                    'total': logs.total,
                    'pages': logs.pages,
                    'has_next': logs.has_next,
                    'has_prev': logs.has_prev
                }
            }
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500