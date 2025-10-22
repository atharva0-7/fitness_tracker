#!/usr/bin/env python3

from flask import Flask, request, jsonify
from flask_cors import CORS
import os
from dotenv import load_dotenv
import google.generativeai as genai

# Load environment variables
load_dotenv()

# Initialize Flask app
app = Flask(__name__)
CORS(app)

# Configure Gemini API
api_key = os.getenv('GEMINI_API_KEY') or 'AIzaSyApYvFQrAPKGEdDuCBJ8Rp2AcQ39OlPvT0'
if api_key:
    genai.configure(api_key=api_key)
    model = genai.GenerativeModel('gemini-2.5-flash')
    print("✅ Using Gemini 2.5 Flash model")
else:
    model = None
    print("❌ No Gemini API key found")

@app.route('/api/ai/health', methods=['GET'])
def health_check():
    """Health check endpoint for AI service"""
    try:
        if model:
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

@app.route('/api/ai/chat', methods=['POST'])
def chat_with_ai():
    """Chat with AI assistant"""
    try:
        data = request.get_json()
        
        if not data or 'message' not in data:
            return jsonify({'error': 'Message is required'}), 400
        
        message = data['message']
        context = data.get('context', 'fitness_nutrition_assistant')
        
        if not model:
            return jsonify({
                'response': 'AI service is not available. Please try again later.',
                'status': 'error'
            }), 500
        
        # Generate AI response
        prompt = f"""You are FitAI, an AI fitness and nutrition assistant. 
Help the user with their fitness and nutrition questions.

User message: {message}

Context: {context}

Please provide a helpful, encouraging, and informative response.
Keep your response concise but comprehensive.
"""
        
        response = model.generate_content(prompt)
        
        return jsonify({
            'response': response.text,
            'status': 'success'
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/ai/workout-plan', methods=['POST'])
def generate_workout():
    """Generate personalized workout plan"""
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        if not model:
            return jsonify({'error': 'AI service not available'}), 500
        
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
        
        prompt = f"""Create a personalized workout plan for a user with the following details:
- Fitness Goal: {user_data['fitness_goal']}
- Current Weight: {user_data['current_weight']} kg
- Target Weight: {user_data['target_weight']} kg
- Height: {user_data['height']} cm
- Body Type: {user_data['body_type']}
- Activity Level: {user_data['activity_level']}
- Workout Duration: {user_data['workout_duration']} minutes
- Days Per Week: {user_data['days_per_week']}
- Difficulty Level: {user_data['difficulty']}

Please provide a structured workout plan with exercises, sets, reps, and rest periods.
Format the response in a clear, structured way."""
        
        response = model.generate_content(prompt)
        
        return jsonify({
            'plan_name': f"Personalized {user_data['difficulty']} Workout Plan",
            'description': response.text,
            'status': 'success'
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/ai/meal-plan', methods=['POST'])
def generate_meal_plan():
    """Generate personalized meal plan"""
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        if not model:
            return jsonify({'error': 'AI service not available'}), 500
        
        # Use provided data or defaults
        user_data = {
            'target_calories': data.get('target_calories', 2000),
            'dietary_preference': data.get('dietary_preference', 'balanced'),
            'allergies': data.get('allergies', []),
            'days': data.get('days', 7)
        }
        
        prompt = f"""Create a personalized meal plan for a user with the following details:
- Target Calories: {user_data['target_calories']} per day
- Dietary Preference: {user_data['dietary_preference']}
- Allergies: {', '.join(user_data['allergies']) if user_data['allergies'] else 'None'}
- Days: {user_data['days']}

Please provide a structured meal plan with daily meals, ingredients, and nutritional information.
Format the response in a clear, structured way."""
        
        response = model.generate_content(prompt)
        
        return jsonify({
            'plan_name': f"Personalized {user_data['dietary_preference']} Meal Plan",
            'description': response.text,
            'status': 'success'
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/ai/nutrition-analysis', methods=['POST'])
def analyze_nutrition():
    """Analyze nutrition data"""
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        if not model:
            return jsonify({'error': 'AI service not available'}), 500
        
        # Use provided data or defaults
        nutrition_data = {
            'calories_consumed': data.get('calories_consumed', 0),
            'target_calories': data.get('target_calories', 2000),
            'protein': data.get('protein', 0),
            'carbs': data.get('carbs', 0),
            'fat': data.get('fat', 0)
        }
        
        prompt = f"""Analyze the following nutrition data and provide insights:
- Calories Consumed: {nutrition_data['calories_consumed']}
- Target Calories: {nutrition_data['target_calories']}
- Protein: {nutrition_data['protein']}g
- Carbs: {nutrition_data['carbs']}g
- Fat: {nutrition_data['fat']}g

Please provide:
1. Overall nutrition assessment
2. Areas that need improvement
3. Specific recommendations
4. Meal suggestions for the next day

Format as a clear analysis with recommendations."""
        
        response = model.generate_content(prompt)
        
        return jsonify({
            'overall_assessment': response.text,
            'status': 'success'
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    print("🚀 Starting FitAI Backend Server...")
    print("✅ Gemini API configured")
    print("🌐 Server running on http://localhost:5001")
    app.run(debug=True, host='0.0.0.0', port=5001)
