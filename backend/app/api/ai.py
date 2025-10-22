from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.services.ai_service import AIService
from app.models.user import User, UserGoals, UserPreferences
from app import db

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
        user_id = get_jwt_identity()
        data = request.get_json()
        
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        # Get user data
        user = User.query.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        # Prepare user data for AI
        user_data = {
            'fitness_goal': data.get('fitness_goal', user.goals.fitness_goal if user.goals else 'general_fitness'),
            'current_weight': data.get('current_weight', user.goals.current_weight if user.goals else 70),
            'target_weight': data.get('target_weight', user.goals.target_weight if user.goals else 70),
            'height': data.get('height', user.goals.height if user.goals else 170),
            'body_type': data.get('body_type', user.goals.body_type if user.goals else 'mesomorph'),
            'activity_level': data.get('activity_level', user.goals.activity_level if user.goals else 'moderate'),
            'workout_types': data.get('workout_types', user.preferences.get_workout_types() if user.preferences else []),
            'available_equipment': data.get('available_equipment', user.preferences.get_available_equipment() if user.preferences else []),
            'workout_duration': data.get('workout_duration', user.preferences.workout_duration if user.preferences else 30),
            'days_per_week': data.get('days_per_week', 3),
            'difficulty': data.get('difficulty', user.preferences.difficulty_level if user.preferences else 'beginner')
        }
        
        workout_plan = ai_service.generate_workout_plan(user_data)
        
        return jsonify({
            'message': 'Workout plan generated successfully',
            'workout_plan': workout_plan
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@ai_bp.route('/generate-meal-plan', methods=['POST'])
@jwt_required()
def generate_meal_plan():
    """Generate personalized meal plan"""
    try:
        user_id = get_jwt_identity()
        data = request.get_json()
        
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        # Get user data
        user = User.query.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        # Prepare user data for AI
        user_data = {
            'target_calories': data.get('target_calories', user.goals.target_calories if user.goals else 2000),
            'dietary_preference': data.get('dietary_preference', 'balanced'),
            'allergies': data.get('allergies', user.preferences.get_allergies() if user.preferences else []),
            'meal_types': data.get('meal_types', ['breakfast', 'lunch', 'dinner', 'snack']),
            'days': data.get('days', 7),
            'cooking_time': data.get('cooking_time', '30 minutes'),
            'cooking_skill': data.get('cooking_skill', 'beginner')
        }
        
        meal_plan = ai_service.generate_meal_plan(user_data)
        
        return jsonify({
            'message': 'Meal plan generated successfully',
            'meal_plan': meal_plan
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@ai_bp.route('/analyze-nutrition', methods=['POST'])
@jwt_required()
def analyze_nutrition():
    """Analyze nutrition data and provide insights"""
    try:
        user_id = get_jwt_identity()
        data = request.get_json()
        
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        # Get user goals for context
        user = User.query.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        # Prepare nutrition data for AI analysis
        nutrition_data = {
            'calories_consumed': data.get('calories_consumed', 0),
            'target_calories': data.get('target_calories', user.goals.target_calories if user.goals else 2000),
            'protein': data.get('protein', 0),
            'carbs': data.get('carbs', 0),
            'fat': data.get('fat', 0),
            'fiber': data.get('fiber', 0),
            'sugar': data.get('sugar', 0),
            'sodium': data.get('sodium', 0),
            'fitness_goal': user.goals.fitness_goal if user.goals else 'general_fitness',
            'target_protein': user.goals.target_protein if user.goals else 150,
            'target_carbs': user.goals.target_carbs if user.goals else 250,
            'target_fat': user.goals.target_fat if user.goals else 67
        }
        
        analysis = ai_service.analyze_nutrition(nutrition_data)
        
        return jsonify({
            'message': 'Nutrition analysis completed successfully',
            'analysis': analysis
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@ai_bp.route('/get-recommendations', methods=['POST'])
@jwt_required()
def get_recommendations():
    """Get personalized recommendations based on user data"""
    try:
        user_id = get_jwt_identity()
        data = request.get_json()
        
        if not data or 'category' not in data:
            return jsonify({'error': 'Category is required'}), 400
        
        category = data['category']
        
        # Get user data
        user = User.query.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        # Prepare context based on category
        if category == 'workout':
            context = f"""
            User wants workout recommendations:
            - Fitness Goal: {user.goals.fitness_goal if user.goals else 'general_fitness'}
            - Current Weight: {user.goals.current_weight if user.goals else 70} kg
            - Target Weight: {user.goals.target_weight if user.goals else 70} kg
            - Activity Level: {user.goals.activity_level if user.goals else 'moderate'}
            - Available Equipment: {user.preferences.get_available_equipment() if user.preferences else []}
            - Workout Duration: {user.preferences.workout_duration if user.preferences else 30} minutes
            """
        elif category == 'nutrition':
            context = f"""
            User wants nutrition recommendations:
            - Target Calories: {user.goals.target_calories if user.goals else 2000}
            - Dietary Preferences: {user.preferences.get_dietary_preferences() if user.preferences else []}
            - Allergies: {user.preferences.get_allergies() if user.preferences else []}
            - Fitness Goal: {user.goals.fitness_goal if user.goals else 'general_fitness'}
            """
        else:
            context = f"""
            User wants {category} recommendations:
            - Fitness Goal: {user.goals.fitness_goal if user.goals else 'general_fitness'}
            - Current Weight: {user.goals.current_weight if user.goals else 70} kg
            - Target Weight: {user.goals.target_weight if user.goals else 70} kg
            """
        
        message = f"Please provide personalized {category} recommendations for this user."
        response = ai_service.chat_with_ai(message, context)
        
        return jsonify({
            'message': f'{category.title()} recommendations generated successfully',
            'recommendations': response
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@ai_bp.route('/voice-input', methods=['POST'])
@jwt_required()
def process_voice_input():
    """Process voice input and return response"""
    try:
        user_id = get_jwt_identity()
        data = request.get_json()
        
        if not data or 'audio_text' not in data:
            return jsonify({'error': 'Audio text is required'}), 400
        
        audio_text = data['audio_text']
        
        # Process the voice input with AI
        response = ai_service.chat_with_ai(audio_text)
        
        return jsonify({
            'message': 'Voice input processed successfully',
            'response': response
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
