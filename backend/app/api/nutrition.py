from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.models.meal import NutritionLog
from app.models.user import User
from app.services.ai_service import AIService
from app import db
from datetime import datetime, date, timedelta
import uuid

nutrition_bp = Blueprint('nutrition', __name__)
ai_service = AIService()

@nutrition_bp.route('/daily', methods=['GET'])
@jwt_required()
def get_daily_nutrition():
    """Get daily nutrition summary"""
    try:
        user_id = get_jwt_identity()
        target_date = request.args.get('date')
        
        if target_date:
            filter_date = datetime.fromisoformat(target_date).date()
        else:
            filter_date = date.today()
        
        # Get nutrition logs for the date
        start_datetime = datetime.combine(filter_date, datetime.min.time())
        end_datetime = start_datetime + timedelta(days=1)
        
        logs = NutritionLog.query.filter(
            NutritionLog.user_id == user_id,
            NutritionLog.consumed_at >= start_datetime,
            NutritionLog.consumed_at < end_datetime
        ).all()
        
        # Calculate totals
        total_calories = sum(log.calories for log in logs)
        total_protein = sum(log.protein for log in logs)
        total_carbs = sum(log.carbs for log in logs)
        total_fat = sum(log.fat for log in logs)
        
        # Get user goals for comparison
        user = User.query.get(user_id)
        target_calories = 2000  # Default, should come from user goals
        
        return jsonify({
            'success': True,
            'data': {
                'date': filter_date.isoformat(),
                'nutrition': {
                    'calories': {
                        'consumed': total_calories,
                        'target': target_calories,
                        'remaining': max(0, target_calories - total_calories)
                    },
                    'protein': {
                        'consumed': total_protein,
                        'target': target_calories * 0.25 / 4,  # 25% of calories from protein
                        'remaining': max(0, (target_calories * 0.25 / 4) - total_protein)
                    },
                    'carbs': {
                        'consumed': total_carbs,
                        'target': target_calories * 0.45 / 4,  # 45% of calories from carbs
                        'remaining': max(0, (target_calories * 0.45 / 4) - total_carbs)
                    },
                    'fat': {
                        'consumed': total_fat,
                        'target': target_calories * 0.30 / 9,  # 30% of calories from fat
                        'remaining': max(0, (target_calories * 0.30 / 9) - total_fat)
                    }
                },
                'meals': [
                    {
                        'id': log.id,
                        'meal_id': log.meal_id,
                        'consumed_at': log.consumed_at.isoformat(),
                        'serving_size': log.serving_size,
                        'calories': log.calories,
                        'protein': log.protein,
                        'carbs': log.carbs,
                        'fat': log.fat,
                        'notes': log.notes
                    }
                    for log in logs
                ]
            }
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@nutrition_bp.route('/log', methods=['POST'])
@jwt_required()
def log_nutrition():
    """Log custom nutrition entry"""
    try:
        user_id = get_jwt_identity()
        data = request.get_json()
        
        # Validate required fields
        required_fields = ['calories', 'protein', 'carbs', 'fat']
        for field in required_fields:
            if field not in data:
                return jsonify({'error': f'{field} is required'}), 400
        
        # Create nutrition log entry
        nutrition_log = NutritionLog(
            id=str(uuid.uuid4()),
            user_id=user_id,
            meal_id=None,  # Custom entry
            consumed_at=datetime.fromisoformat(data.get('consumed_at', datetime.utcnow().isoformat())),
            serving_size=data.get('serving_size', 1.0),
            calories=data['calories'],
            protein=data['protein'],
            carbs=data['carbs'],
            fat=data['fat'],
            notes=data.get('notes', ''),
            created_at=datetime.utcnow()
        )
        
        db.session.add(nutrition_log)
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Nutrition logged successfully',
            'data': {
                'log_id': nutrition_log.id,
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

@nutrition_bp.route('/macros', methods=['GET'])
@jwt_required()
def get_macro_breakdown():
    """Get macro breakdown for a specific date"""
    try:
        user_id = get_jwt_identity()
        target_date = request.args.get('date')
        
        if target_date:
            filter_date = datetime.fromisoformat(target_date).date()
        else:
            filter_date = date.today()
        
        # Get nutrition logs for the date
        start_datetime = datetime.combine(filter_date, datetime.min.time())
        end_datetime = start_datetime + timedelta(days=1)
        
        logs = NutritionLog.query.filter(
            NutritionLog.user_id == user_id,
            NutritionLog.consumed_at >= start_datetime,
            NutritionLog.consumed_at < end_datetime
        ).all()
        
        # Calculate macro breakdown
        total_calories = sum(log.calories for log in logs)
        total_protein = sum(log.protein for log in logs)
        total_carbs = sum(log.carbs for log in logs)
        total_fat = sum(log.fat for log in logs)
        
        # Calculate percentages
        protein_calories = total_protein * 4
        carbs_calories = total_carbs * 4
        fat_calories = total_fat * 9
        
        if total_calories > 0:
            protein_percentage = (protein_calories / total_calories) * 100
            carbs_percentage = (carbs_calories / total_calories) * 100
            fat_percentage = (fat_calories / total_calories) * 100
        else:
            protein_percentage = carbs_percentage = fat_percentage = 0
        
        return jsonify({
            'success': True,
            'data': {
                'date': filter_date.isoformat(),
                'total_calories': total_calories,
                'macros': {
                    'protein': {
                        'grams': total_protein,
                        'calories': protein_calories,
                        'percentage': round(protein_percentage, 1)
                    },
                    'carbs': {
                        'grams': total_carbs,
                        'calories': carbs_calories,
                        'percentage': round(carbs_percentage, 1)
                    },
                    'fat': {
                        'grams': total_fat,
                        'calories': fat_calories,
                        'percentage': round(fat_percentage, 1)
                    }
                },
                'recommendations': {
                    'protein_target': total_calories * 0.25 / 4,  # 25% of calories
                    'carbs_target': total_calories * 0.45 / 4,   # 45% of calories
                    'fat_target': total_calories * 0.30 / 9      # 30% of calories
                }
            }
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@nutrition_bp.route('/analyze', methods=['POST'])
@jwt_required()
def analyze_nutrition():
    """Get AI analysis of nutrition data"""
    try:
        user_id = get_jwt_identity()
        data = request.get_json()
        
        # Get user for context
        user = User.query.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        # Prepare nutrition data for AI analysis
        nutrition_data = {
            'calories_consumed': data.get('calories_consumed', 0),
            'target_calories': data.get('target_calories', 2000),
            'protein': data.get('protein', 0),
            'carbs': data.get('carbs', 0),
            'fat': data.get('fat', 0),
            'fiber': data.get('fiber', 0),
            'sugar': data.get('sugar', 0),
            'sodium': data.get('sodium', 0),
            'fitness_goal': data.get('fitness_goal', 'general_fitness'),
            'target_protein': data.get('target_protein', 150),
            'target_carbs': data.get('target_carbs', 250),
            'target_fat': data.get('target_fat', 67)
        }
        
        # Get AI analysis
        analysis = ai_service.analyze_nutrition(nutrition_data)
        
        return jsonify({
            'success': True,
            'data': {
                'analysis': analysis,
                'nutrition_data': nutrition_data
            }
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500