from flask import Blueprint, request, jsonify
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from werkzeug.security import generate_password_hash, check_password_hash
from app.models.user import User, UserGoals, UserPreferences
from app import db
from datetime import datetime
import uuid

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/register', methods=['POST'])
def register():
    """Register a new user"""
    try:
        data = request.get_json()
        
        # Validate required fields
        required_fields = ['email', 'password', 'name', 'age', 'gender', 'height', 'weight']
        for field in required_fields:
            if field not in data or not data[field]:
                return jsonify({'error': f'{field} is required'}), 400
        
        # Check if user already exists
        if User.query.filter_by(email=data['email']).first():
            return jsonify({'error': 'User already exists'}), 409
        
        # Create new user
        user = User(
            id=str(uuid.uuid4()),
            email=data['email'],
            password_hash=generate_password_hash(data['password']),
            name=data['name'],
            age=data['age'],
            gender=data['gender'],
            height=data['height'],
            weight=data['weight'],
            activity_level=data.get('activity_level', 'moderate'),
            created_at=datetime.utcnow()
        )
        
        db.session.add(user)
        
        # Create default goals
        goals = UserGoals(
            id=str(uuid.uuid4()),
            user_id=user.id,
            fitness_goal=data.get('fitness_goal', 'general_fitness'),
            target_weight=data.get('target_weight', data['weight']),
            target_date=data.get('target_date'),
            workout_frequency=data.get('workout_frequency', 3),
            preferred_workout_types=data.get('preferred_workout_types', []),
            created_at=datetime.utcnow()
        )
        
        # Create default preferences
        preferences = UserPreferences(
            id=str(uuid.uuid4()),
            user_id=user.id,
            dietary_preference=data.get('dietary_preference', 'balanced'),
            allergies=data.get('allergies', []),
            notifications_enabled=True,
            created_at=datetime.utcnow()
        )
        
        db.session.add(goals)
        db.session.add(preferences)
        db.session.commit()
        
        # Create access token
        access_token = create_access_token(identity=user.id)
        
        return jsonify({
            'success': True,
            'message': 'User registered successfully',
            'data': {
                'user_id': user.id,
                'email': user.email,
                'name': user.name,
                'access_token': access_token
            }
        }), 201
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@auth_bp.route('/login', methods=['POST'])
def login():
    """Login user"""
    try:
        data = request.get_json()
        
        if not data or 'email' not in data or 'password' not in data:
            return jsonify({'error': 'Email and password are required'}), 400
        
        user = User.query.filter_by(email=data['email']).first()
        
        if not user or not check_password_hash(user.password_hash, data['password']):
            return jsonify({'error': 'Invalid credentials'}), 401
        
        # Create access token
        access_token = create_access_token(identity=user.id)
        
        return jsonify({
            'success': True,
            'message': 'Login successful',
            'data': {
                'user_id': user.id,
                'email': user.email,
                'name': user.name,
                'access_token': access_token
            }
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@auth_bp.route('/logout', methods=['POST'])
@jwt_required()
def logout():
    """Logout user (client-side token removal)"""
    return jsonify({
        'success': True,
        'message': 'Logout successful'
    }), 200

@auth_bp.route('/me', methods=['GET'])
@jwt_required()
def get_current_user():
    """Get current user information"""
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
                'created_at': user.created_at.isoformat()
            }
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500