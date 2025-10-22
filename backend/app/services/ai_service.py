import google.generativeai as genai
import os
from typing import Dict, List, Any
import json

class AIService:
    def __init__(self):
        # Configure Gemini API
        api_key = os.getenv('GEMINI_API_KEY')
        if api_key:
            genai.configure(api_key=api_key)
            # Use Gemini 2.5 Flash model
            self.model = genai.GenerativeModel('gemini-2.5-flash')
            print("✅ Using Gemini 2.5 Flash model")
        else:
            self.model = None
            print("❌ No Gemini API key found")
    
    def generate_workout_plan(self, user_data: Dict[str, Any]) -> Dict[str, Any]:
        """Generate a personalized workout plan using AI"""
        if not self.model:
            return self._get_default_workout_plan(user_data)
        
        try:
            prompt = f"""
            Create a personalized workout plan for a user with the following details:
            - Fitness Goal: {user_data.get('fitness_goal', 'general_fitness')}
            - Current Weight: {user_data.get('current_weight', 70)} kg
            - Target Weight: {user_data.get('target_weight', 70)} kg
            - Height: {user_data.get('height', 170)} cm
            - Body Type: {user_data.get('body_type', 'mesomorph')}
            - Activity Level: {user_data.get('activity_level', 'moderate')}
            - Preferred Workout Types: {user_data.get('workout_types', [])}
            - Available Equipment: {user_data.get('available_equipment', [])}
            - Workout Duration: {user_data.get('workout_duration', 30)} minutes
            - Days Per Week: {user_data.get('days_per_week', 3)}
            - Difficulty Level: {user_data.get('difficulty', 'beginner')}
            
            Please provide a structured workout plan with:
            1. A 4-week plan with daily workouts
            2. Each workout should include specific exercises with sets, reps, and rest periods
            3. Include warm-up and cool-down routines
            4. Provide modifications for different fitness levels
            5. Include rest days and recovery recommendations
            
            Format the response as a JSON object with the following structure:
            {{
                "plan_name": "string",
                "description": "string",
                "total_weeks": 4,
                "difficulty": "string",
                "weeks": [
                    {{
                        "week_number": 1,
                        "days": [
                            {{
                                "day_number": 1,
                                "day_name": "Monday",
                                "workout_type": "string",
                                "duration_minutes": 30,
                                "exercises": [
                                    {{
                                        "name": "string",
                                        "sets": 3,
                                        "reps": "12-15",
                                        "rest_seconds": 60,
                                        "instructions": "string",
                                        "muscles_targeted": ["string"],
                                        "equipment": "string"
                                    }}
                                ],
                                "warm_up": ["string"],
                                "cool_down": ["string"]
                            }}
                        ]
                    }}
                ]
            }}
            """
            
            response = self.model.generate_content(prompt)
            # Parse the response and return structured data
            # Note: In a real implementation, you'd need to parse the JSON response
            return self._parse_workout_response(response.text)
            
        except Exception as e:
            print(f"Error generating workout plan: {e}")
            return self._get_default_workout_plan(user_data)
    
    def generate_meal_plan(self, user_data: Dict[str, Any]) -> Dict[str, Any]:
        """Generate a personalized meal plan using AI"""
        if not self.model:
            return self._get_default_meal_plan(user_data)
        
        try:
            prompt = f"""
            Create a personalized meal plan for a user with the following details:
            - Target Calories: {user_data.get('target_calories', 2000)} per day
            - Dietary Preference: {user_data.get('dietary_preference', 'balanced')}
            - Allergies: {user_data.get('allergies', [])}
            - Meal Types: {user_data.get('meal_types', ['breakfast', 'lunch', 'dinner', 'snack'])}
            - Days: {user_data.get('days', 7)}
            - Cooking Time: {user_data.get('cooking_time', '30 minutes')}
            - Skill Level: {user_data.get('cooking_skill', 'beginner')}
            
            Please provide a structured meal plan with:
            1. Daily meal plans for the specified number of days
            2. Each meal should include ingredients, instructions, and nutritional information
            3. Include portion sizes and serving information
            4. Provide shopping list for the week
            5. Include meal prep tips and storage instructions
            
            Format the response as a JSON object with the following structure:
            {{
                "plan_name": "string",
                "description": "string",
                "target_calories": 2000,
                "dietary_preference": "string",
                "days": [
                    {{
                        "day_number": 1,
                        "date": "2024-01-01",
                        "meals": [
                            {{
                                "meal_type": "breakfast",
                                "time": "08:00",
                                "name": "string",
                                "calories": 500,
                                "protein": 25,
                                "carbs": 60,
                                "fat": 20,
                                "ingredients": ["string"],
                                "instructions": ["string"],
                                "prep_time": 15,
                                "cook_time": 10
                            }}
                        ],
                        "total_calories": 2000,
                        "total_protein": 150,
                        "total_carbs": 250,
                        "total_fat": 67
                    }}
                ],
                "shopping_list": ["string"],
                "meal_prep_tips": ["string"]
            }}
            """
            
            response = self.model.generate_content(prompt)
            return self._parse_meal_response(response.text)
            
        except Exception as e:
            print(f"Error generating meal plan: {e}")
            return self._get_default_meal_plan(user_data)
    
    def chat_with_ai(self, message: str, context: str = None) -> str:
        """Chat with AI assistant"""
        if not self.model:
            return "AI service is not available. Please try again later."
        
        try:
            prompt = f"""
            You are FitAI, an AI fitness and nutrition assistant. 
            Help the user with their fitness and nutrition questions.
            
            User message: {message}
            
            Context: {context or 'No specific context provided'}
            
            Please provide a helpful, encouraging, and informative response.
            Keep your response concise but comprehensive.
            """
            
            response = self.model.generate_content(prompt)
            return response.text
            
        except Exception as e:
            print(f"Error in AI chat: {e}")
            return "I'm sorry, I'm having trouble processing your request. Please try again later."
    
    def analyze_nutrition(self, nutrition_data: Dict[str, Any]) -> Dict[str, Any]:
        """Analyze nutrition data and provide insights"""
        if not self.model:
            return self._get_default_nutrition_analysis(nutrition_data)
        
        try:
            prompt = f"""
            Analyze the following nutrition data and provide insights:
            
            Daily Nutrition:
            - Calories Consumed: {nutrition_data.get('calories_consumed', 0)}
            - Target Calories: {nutrition_data.get('target_calories', 2000)}
            - Protein: {nutrition_data.get('protein', 0)}g
            - Carbs: {nutrition_data.get('carbs', 0)}g
            - Fat: {nutrition_data.get('fat', 0)}g
            - Fiber: {nutrition_data.get('fiber', 0)}g
            - Sugar: {nutrition_data.get('sugar', 0)}g
            - Sodium: {nutrition_data.get('sodium', 0)}mg
            
            User Goals:
            - Fitness Goal: {nutrition_data.get('fitness_goal', 'general_fitness')}
            - Target Protein: {nutrition_data.get('target_protein', 150)}g
            - Target Carbs: {nutrition_data.get('target_carbs', 250)}g
            - Target Fat: {nutrition_data.get('target_fat', 67)}g
            
            Please provide:
            1. Overall nutrition assessment
            2. Areas that need improvement
            3. Specific recommendations
            4. Meal suggestions for the next day
            5. Macro balance analysis
            
            Format as a JSON object with analysis and recommendations.
            """
            
            response = self.model.generate_content(prompt)
            return self._parse_nutrition_response(response.text)
            
        except Exception as e:
            print(f"Error analyzing nutrition: {e}")
            return self._get_default_nutrition_analysis(nutrition_data)
    
    def _get_default_workout_plan(self, user_data: Dict[str, Any]) -> Dict[str, Any]:
        """Fallback workout plan when AI is not available"""
        return {
            "plan_name": "Basic Fitness Plan",
            "description": "A beginner-friendly workout plan",
            "total_weeks": 4,
            "difficulty": user_data.get('difficulty', 'beginner'),
            "weeks": [
                {
                    "week_number": 1,
                    "days": [
                        {
                            "day_number": 1,
                            "day_name": "Monday",
                            "workout_type": "Full Body",
                            "duration_minutes": 30,
                            "exercises": [
                                {
                                    "name": "Push-ups",
                                    "sets": 3,
                                    "reps": "8-12",
                                    "rest_seconds": 60,
                                    "instructions": "Keep your body straight and lower until chest nearly touches floor",
                                    "muscles_targeted": ["chest", "shoulders", "triceps"],
                                    "equipment": "bodyweight"
                                },
                                {
                                    "name": "Squats",
                                    "sets": 3,
                                    "reps": "12-15",
                                    "rest_seconds": 60,
                                    "instructions": "Lower until thighs are parallel to floor",
                                    "muscles_targeted": ["quadriceps", "glutes"],
                                    "equipment": "bodyweight"
                                }
                            ],
                            "warm_up": ["Arm circles", "Leg swings", "Light jogging in place"],
                            "cool_down": ["Stretching", "Deep breathing"]
                        }
                    ]
                }
            ]
        }
    
    def _get_default_meal_plan(self, user_data: Dict[str, Any]) -> Dict[str, Any]:
        """Fallback meal plan when AI is not available"""
        return {
            "plan_name": "Balanced Meal Plan",
            "description": "A balanced meal plan for healthy eating",
            "target_calories": user_data.get('target_calories', 2000),
            "dietary_preference": user_data.get('dietary_preference', 'balanced'),
            "days": [
                {
                    "day_number": 1,
                    "date": "2024-01-01",
                    "meals": [
                        {
                            "meal_type": "breakfast",
                            "time": "08:00",
                            "name": "Oatmeal with Berries",
                            "calories": 400,
                            "protein": 15,
                            "carbs": 60,
                            "fat": 10,
                            "ingredients": ["Oats", "Mixed berries", "Almond milk", "Honey"],
                            "instructions": ["Cook oats with almond milk", "Top with berries and honey"],
                            "prep_time": 5,
                            "cook_time": 10
                        }
                    ],
                    "total_calories": 2000,
                    "total_protein": 150,
                    "total_carbs": 250,
                    "total_fat": 67
                }
            ],
            "shopping_list": ["Oats", "Mixed berries", "Almond milk", "Honey"],
            "meal_prep_tips": ["Prepare oats the night before", "Wash berries in advance"]
        }
    
    def _get_default_nutrition_analysis(self, nutrition_data: Dict[str, Any]) -> Dict[str, Any]:
        """Fallback nutrition analysis when AI is not available"""
        return {
            "overall_assessment": "Good nutrition balance",
            "areas_for_improvement": ["Increase protein intake", "Reduce sugar consumption"],
            "recommendations": ["Add more lean protein", "Include more vegetables"],
            "meal_suggestions": ["Grilled chicken with vegetables", "Quinoa salad"],
            "macro_balance": "Well balanced macros"
        }
    
    def _parse_workout_response(self, response_text: str) -> Dict[str, Any]:
        """Parse AI workout response"""
        try:
            # Extract JSON from response
            start = response_text.find('{')
            end = response_text.rfind('}') + 1
            json_str = response_text[start:end]
            return json.loads(json_str)
        except:
            return self._get_default_workout_plan({})
    
    def _parse_meal_response(self, response_text: str) -> Dict[str, Any]:
        """Parse AI meal response"""
        try:
            # Extract JSON from response
            start = response_text.find('{')
            end = response_text.rfind('}') + 1
            json_str = response_text[start:end]
            return json.loads(json_str)
        except:
            return self._get_default_meal_plan({})
    
    def _parse_nutrition_response(self, response_text: str) -> Dict[str, Any]:
        """Parse AI nutrition response"""
        try:
            # Extract JSON from response
            start = response_text.find('{')
            end = response_text.rfind('}') + 1
            json_str = response_text[start:end]
            return json.loads(json_str)
        except:
            return self._get_default_nutrition_analysis({})
