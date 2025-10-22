from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.models.user import User, UserGoals, UserPreferences
from app import db
from datetime import datetime
import uuid

user_bp = Blueprint('user', __name__)

@user_bp.route('/profile', methods=['GET'])
@jwt_required()
def get_profile():
    """Get user profile"""
    try:
        user_id = get_jwt_identity()
        user = User.query.get(user_id)
        
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        return jsonify({
            'success': True,
            'data': {
                'user_id': user.id,
                'email': user.email,
                'name': user.name,
                'age': user.age,
                'gender': user.gender,
                'height': user.height,
                'weight': user.weight,
                'activity_level': user.activity_level,
                'created_at': user.created_at.isoformat(),
                'updated_at': user.updated_at.isoformat() if user.updated_at else None
            }
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@user_bp.route('/profile', methods=['PUT'])
@jwt_required()
def update_profile():
    """Update user profile"""
    try:
        user_id = get_jwt_identity()
        user = User.query.get(user_id)
        
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        data = request.get_json()
        
        # Update allowed fields
        if 'name' in data:
            user.name = data['name']
        if 'age' in data:
            user.age = data['age']
        if 'height' in data:
            user.height = data['height']
        if 'weight' in data:
            user.weight = data['weight']
        if 'activity_level' in data:
            user.activity_level = data['activity_level']
        
        user.updated_at = datetime.utcnow()
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Profile updated successfully',
            'data': {
                'user_id': user.id,
                'email': user.email,
                'name': user.name,
                'age': user.age,
                'gender': user.gender,
                'height': user.height,
                'weight': user.weight,
                'activity_level': user.activity_level,
                'updated_at': user.updated_at.isoformat()
            }
        }), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@user_bp.route('/goals', methods=['GET'])
@jwt_required()
def get_goals():
    """Get user goals"""
    try:
        user_id = get_jwt_identity()
        goals = UserGoals.query.filter_by(user_id=user_id).first()
        
        if not goals:
            return jsonify({'error': 'Goals not found'}), 404
        
        return jsonify({
            'success': True,
            'data': {
                'goals_id': goals.id,
                'fitness_goal': goals.fitness_goal,
                'target_weight': goals.target_weight,
                'target_date': goals.target_date.isoformat() if goals.target_date else None,
                'workout_frequency': goals.workout_frequency,
                'preferred_workout_types': goals.preferred_workout_types,
                'created_at': goals.created_at.isoformat(),
                'updated_at': goals.updated_at.isoformat() if goals.updated_at else None
            }
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@user_bp.route('/goals', methods=['PUT'])
@jwt_required()
def update_goals():
    """Update user goals"""
    try:
        user_id = get_jwt_identity()
        goals = UserGoals.query.filter_by(user_id=user_id).first()
        
        if not goals:
            return jsonify({'error': 'Goals not found'}), 404
        
        data = request.get_json()
        
        # Update allowed fields
        if 'fitness_goal' in data:
            goals.fitness_goal = data['fitness_goal']
        if 'target_weight' in data:
            goals.target_weight = data['target_weight']
        if 'target_date' in data:
            goals.target_date = datetime.fromisoformat(data['target_date']) if data['target_date'] else None
        if 'workout_frequency' in data:
            goals.workout_frequency = data['workout_frequency']
        if 'preferred_workout_types' in data:
            goals.preferred_workout_types = data['preferred_workout_types']
        
        goals.updated_at = datetime.utcnow()
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Goals updated successfully',
            'data': {
                'goals_id': goals.id,
                'fitness_goal': goals.fitness_goal,
                'target_weight': goals.target_weight,
                'target_date': goals.target_date.isoformat() if goals.target_date else None,
                'workout_frequency': goals.workout_frequency,
                'preferred_workout_types': goals.preferred_workout_types,
                'updated_at': goals.updated_at.isoformat()
            }
        }), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@user_bp.route('/preferences', methods=['GET'])
@jwt_required()
def get_preferences():
    """Get user preferences"""
    try:
        user_id = get_jwt_identity()
        preferences = UserPreferences.query.filter_by(user_id=user_id).first()
        
        if not preferences:
            return jsonify({'error': 'Preferences not found'}), 404
        
        return jsonify({
            'success': True,
            'data': {
                'preferences_id': preferences.id,
                'dietary_preference': preferences.dietary_preference,
                'allergies': preferences.allergies,
                'notifications_enabled': preferences.notifications_enabled,
                'created_at': preferences.created_at.isoformat(),
                'updated_at': preferences.updated_at.isoformat() if preferences.updated_at else None
            }
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@user_bp.route('/preferences', methods=['PUT'])
@jwt_required()
def update_preferences():
    """Update user preferences"""
    try:
        user_id = get_jwt_identity()
        preferences = UserPreferences.query.filter_by(user_id=user_id).first()
        
        if not preferences:
            return jsonify({'error': 'Preferences not found'}), 404
        
        data = request.get_json()
        
        # Update allowed fields
        if 'dietary_preference' in data:
            preferences.dietary_preference = data['dietary_preference']
        if 'allergies' in data:
            preferences.allergies = data['allergies']
        if 'notifications_enabled' in data:
            preferences.notifications_enabled = data['notifications_enabled']
        
        preferences.updated_at = datetime.utcnow()
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Preferences updated successfully',
            'data': {
                'preferences_id': preferences.id,
                'dietary_preference': preferences.dietary_preference,
                'allergies': preferences.allergies,
                'notifications_enabled': preferences.notifications_enabled,
                'updated_at': preferences.updated_at.isoformat()
            }
        }), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500