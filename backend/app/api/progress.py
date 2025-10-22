from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.models.progress import Progress, WeightProgress, BmiProgress, CalorieProgress
from app import db
from datetime import datetime, date, timedelta
import uuid

progress_bp = Blueprint('progress', __name__)

@progress_bp.route('/weight', methods=['GET'])
@jwt_required()
def get_weight_progress():
    """Get weight progress data"""
    try:
        user_id = get_jwt_identity()
        start_date = request.args.get('start_date')
        end_date = request.args.get('end_date')
        
        query = WeightProgress.query.filter(WeightProgress.user_id == user_id)
        
        if start_date:
            query = query.filter(WeightProgress.date >= datetime.strptime(start_date, '%Y-%m-%d').date())
        if end_date:
            query = query.filter(WeightProgress.date <= datetime.strptime(end_date, '%Y-%m-%d').date())
        
        progress = query.order_by(WeightProgress.date.desc()).all()
        
        return jsonify({
            'weight_progress': [p.to_dict() for p in progress]
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@progress_bp.route('/weight', methods=['POST'])
@jwt_required()
def log_weight():
    """Log weight data"""
    try:
        user_id = get_jwt_identity()
        data = request.get_json()
        
        if not data or 'weight' not in data:
            return jsonify({'error': 'Weight is required'}), 400
        
        # Create weight progress entry
        weight_progress = WeightProgress(
            id=str(uuid.uuid4()),
            user_id=user_id,
            date=datetime.strptime(data.get('date', date.today().isoformat()), '%Y-%m-%d').date(),
            weight=data['weight'],
            body_fat=data.get('body_fat'),
            muscle_mass=data.get('muscle_mass'),
            notes=data.get('notes', '')
        )
        
        db.session.add(weight_progress)
        db.session.commit()
        
        return jsonify({
            'message': 'Weight logged successfully',
            'weight_progress': weight_progress.to_dict()
        }), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@progress_bp.route('/bmi', methods=['GET'])
@jwt_required()
def get_bmi_progress():
    """Get BMI progress data"""
    try:
        user_id = get_jwt_identity()
        start_date = request.args.get('start_date')
        end_date = request.args.get('end_date')
        
        query = BmiProgress.query.filter(BmiProgress.user_id == user_id)
        
        if start_date:
            query = query.filter(BmiProgress.date >= datetime.strptime(start_date, '%Y-%m-%d').date())
        if end_date:
            query = query.filter(BmiProgress.date <= datetime.strptime(end_date, '%Y-%m-%d').date())
        
        progress = query.order_by(BmiProgress.date.desc()).all()
        
        return jsonify({
            'bmi_progress': [p.to_dict() for p in progress]
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@progress_bp.route('/calories', methods=['GET'])
@jwt_required()
def get_calorie_progress():
    """Get calorie progress data"""
    try:
        user_id = get_jwt_identity()
        start_date = request.args.get('start_date')
        end_date = request.args.get('end_date')
        
        query = CalorieProgress.query.filter(CalorieProgress.user_id == user_id)
        
        if start_date:
            query = query.filter(CalorieProgress.date >= datetime.strptime(start_date, '%Y-%m-%d').date())
        if end_date:
            query = query.filter(CalorieProgress.date <= datetime.strptime(end_date, '%Y-%m-%d').date())
        
        progress = query.order_by(CalorieProgress.date.desc()).all()
        
        return jsonify({
            'calorie_progress': [p.to_dict() for p in progress]
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
