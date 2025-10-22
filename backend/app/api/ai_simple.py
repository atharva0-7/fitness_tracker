from flask import Blueprint, request, jsonify
from app.services.ai_service import AIService

ai_bp = Blueprint('ai', __name__)
ai_service = AIService()

@ai_bp.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint for AI service"""
    try:
        if ai_service.model:
            return jsonify({
                'status': 'healthy',
                'ai_service': 'available',
                'model': 'gemini-2.5-flash'
            }), 200
        else:
            return jsonify({
                'status': 'degraded',
                'ai_service': 'unavailable',
                'message': 'AI model not initialized'
            }), 200
    except Exception as e:
        return jsonify({
            'status': 'error',
            'ai_service': 'error',
            'message': str(e)
        }), 500

@ai_bp.route('/chat', methods=['POST'])
def chat_with_ai():
    """Chat with AI assistant"""
    try:
        data = request.get_json()
        
        if not data or 'message' not in data:
            return jsonify({'error': 'Message is required'}), 400
        
        message = data['message']
        context = data.get('context', 'fitness_nutrition_assistant')
        
        # Generate AI response
        response = ai_service.chat_with_ai(message, context)
        
        return jsonify({
            'response': response,
            'status': 'success'
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@ai_bp.route('/workout-plan', methods=['POST'])
def generate_workout():
    """Generate personalized workout plan"""
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        # Use provided data or defaults
        user_data = {
            'fitness_goal': data.get('fitness_goal', 'general_fitness'),
            'current_weight': data.get('current_weight', 70),
            'target_weight': data.get('target_weight', 70),
            'height': data.get('height', 170),
            'body_type': data.get('body_type', 'mesomorph'),
            'activity_level': data.get('activity_level', 'moderate'),
            'workout_types': data.get('workout_types', []),
            'available_equipment': data.get('available_equipment', []),
            'workout_duration': data.get('workout_duration', 30),
            'days_per_week': data.get('days_per_week', 3),
            'difficulty': data.get('difficulty', 'beginner')
        }
        
        workout_plan = ai_service.generate_workout_plan(user_data)
        
        return jsonify(workout_plan), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@ai_bp.route('/meal-plan', methods=['POST'])
def generate_meal_plan():
    """Generate personalized meal plan"""
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        # Use provided data or defaults
        user_data = {
            'target_calories': data.get('target_calories', 2000),
            'dietary_preference': data.get('dietary_preference', 'balanced'),
            'allergies': data.get('allergies', []),
            'meal_types': data.get('meal_types', ['breakfast', 'lunch', 'dinner', 'snack']),
            'days': data.get('days', 7),
            'cooking_time': data.get('cooking_time', '30 minutes'),
            'cooking_skill': data.get('cooking_skill', 'beginner')
        }
        
        meal_plan = ai_service.generate_meal_plan(user_data)
        
        return jsonify(meal_plan), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@ai_bp.route('/nutrition-analysis', methods=['POST'])
def analyze_nutrition():
    """Analyze nutrition data"""
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        # Use provided data or defaults
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
        
        analysis = ai_service.analyze_nutrition(nutrition_data)
        
        return jsonify(analysis), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
