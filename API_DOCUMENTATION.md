# 📚 API Documentation - FitAI Backend

Complete API reference for the FitAI Flask backend.

## 🔗 Base URL

```
http://localhost:5000/api
```

## 🔐 Authentication

All protected endpoints require a JWT token in the Authorization header:

```
Authorization: Bearer <your-jwt-token>
```

## 📋 API Endpoints

### 🔑 Authentication

#### Register User
```http
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securepassword",
  "name": "John Doe",
  "age": 25,
  "gender": "male",
  "height": 175,
  "weight": 70
}
```

**Response:**
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user_id": "123",
    "email": "user@example.com",
    "name": "John Doe",
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
  }
}
```

#### Login User
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securepassword"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user_id": "123",
    "email": "user@example.com",
    "name": "John Doe",
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
  }
}
```

### 👤 User Management

#### Get User Profile
```http
GET /api/user/profile
Authorization: Bearer <token>
```

#### Update User Profile
```http
PUT /api/user/profile
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "John Smith",
  "age": 26,
  "height": 176,
  "weight": 72,
  "activity_level": "moderate"
}
```

#### Get User Goals
```http
GET /api/user/goals
Authorization: Bearer <token>
```

#### Update User Goals
```http
PUT /api/user/goals
Authorization: Bearer <token>
Content-Type: application/json

{
  "fitness_goal": "weight_loss",
  "target_weight": 65,
  "target_date": "2024-06-01",
  "workout_frequency": 4,
  "preferred_workout_types": ["strength", "cardio"]
}
```

### 💪 Workouts

#### Generate Workout Plan
```http
POST /api/workouts/generate
Authorization: Bearer <token>
Content-Type: application/json

{
  "goal": "weight_loss",
  "difficulty": "intermediate",
  "duration": 45,
  "equipment": ["dumbbells", "mat"],
  "body_parts": ["chest", "back", "legs"],
  "days_per_week": 4
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "workout_plan": {
      "id": "workout_123",
      "name": "Weight Loss Strength Training",
      "description": "A comprehensive workout plan designed for weight loss...",
      "difficulty": "intermediate",
      "duration": 45,
      "exercises": [
        {
          "name": "Push-ups",
          "sets": 3,
          "reps": 12,
          "rest_time": 60,
          "instructions": "Start in plank position..."
        }
      ]
    }
  }
}
```

#### Get Workout by ID
```http
GET /api/workouts/{workout_id}
Authorization: Bearer <token>
```

#### Complete Workout
```http
POST /api/workouts/{workout_id}/complete
Authorization: Bearer <token>
Content-Type: application/json

{
  "duration": 42,
  "calories_burned": 350,
  "notes": "Great workout!",
  "exercises_completed": [
    {
      "exercise_id": "push_ups",
      "sets_completed": 3,
      "reps_completed": [12, 10, 8],
      "weight_used": 0
    }
  ]
}
```

### 🍽️ Meals & Nutrition

#### Generate Meal Plan
```http
POST /api/meals/generate
Authorization: Bearer <token>
Content-Type: application/json

{
  "dietary_preferences": ["vegetarian"],
  "allergies": ["nuts"],
  "calorie_target": 2000,
  "meals_per_day": 3,
  "days": 7
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "meal_plan": {
      "id": "meal_plan_123",
      "name": "Vegetarian Weight Loss Plan",
      "description": "A 7-day vegetarian meal plan...",
      "total_calories": 2000,
      "meals": [
        {
          "day": 1,
          "meal_type": "breakfast",
          "name": "Avocado Toast",
          "calories": 350,
          "ingredients": [
            {
              "name": "Whole grain bread",
              "amount": "2 slices",
              "calories": 160
            }
          ],
          "instructions": "Toast the bread..."
        }
      ]
    }
  }
}
```

#### Log Meal
```http
POST /api/meals/log
Authorization: Bearer <token>
Content-Type: application/json

{
  "meal_id": "meal_123",
  "serving_size": 1.5,
  "consumed_at": "2024-01-15T08:30:00Z",
  "notes": "Added extra avocado"
}
```

#### Get Daily Nutrition
```http
GET /api/nutrition/daily?date=2024-01-15
Authorization: Bearer <token>
```

### 📊 Progress Tracking

#### Track Progress
```http
POST /api/progress/track
Authorization: Bearer <token>
Content-Type: application/json

{
  "date": "2024-01-15",
  "weight": 70.5,
  "body_fat": 15.2,
  "muscle_mass": 35.8,
  "measurements": {
    "chest": 95,
    "waist": 80,
    "hips": 90
  },
  "notes": "Feeling stronger!"
}
```

#### Get Progress Analytics
```http
GET /api/progress/analytics?period=30
Authorization: Bearer <token>
```

**Response:**
```json
{
  "success": true,
  "data": {
    "weight_trend": [
      {"date": "2024-01-01", "weight": 72.0},
      {"date": "2024-01-15", "weight": 70.5}
    ],
    "body_fat_trend": [
      {"date": "2024-01-01", "body_fat": 16.5},
      {"date": "2024-01-15", "body_fat": 15.2}
    ],
    "achievements": [
      {
        "name": "First Week Complete",
        "description": "Completed 4 workouts in your first week",
        "earned_at": "2024-01-07"
      }
    ]
  }
}
```

### 🤖 AI Services

#### Chat with AI
```http
POST /api/ai/chat
Authorization: Bearer <token>
Content-Type: application/json

{
  "message": "I want to lose 10 pounds in 2 months. What should I do?",
  "context": {
    "current_weight": 70,
    "target_weight": 60,
    "activity_level": "moderate"
  }
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "response": "Based on your goals, I recommend a combination of strength training and cardio...",
    "suggestions": [
      "Create a calorie deficit of 500 calories per day",
      "Include 3-4 strength training sessions per week",
      "Add 2-3 cardio sessions for fat burning"
    ]
  }
}
```

#### Process Voice Input
```http
POST /api/ai/voice
Authorization: Bearer <token>
Content-Type: application/json

{
  "audio_data": "base64_encoded_audio",
  "language": "en-US"
}
```

### 📁 File Upload

#### Upload Profile Image
```http
POST /api/upload/profile-image
Authorization: Bearer <token>
Content-Type: multipart/form-data

file: <image_file>
```

#### Upload Workout Image
```http
POST /api/upload/workout-image
Authorization: Bearer <token>
Content-Type: multipart/form-data

file: <image_file>
workout_id: workout_123
```

## 📝 Error Responses

All error responses follow this format:

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": {
      "email": "Invalid email format",
      "password": "Password must be at least 8 characters"
    }
  }
}
```

### Common Error Codes

- `VALIDATION_ERROR` (400): Invalid input data
- `UNAUTHORIZED` (401): Missing or invalid authentication
- `FORBIDDEN` (403): Insufficient permissions
- `NOT_FOUND` (404): Resource not found
- `CONFLICT` (409): Resource already exists
- `INTERNAL_ERROR` (500): Server error

## 🔧 Rate Limiting

- **General API**: 100 requests per minute per user
- **AI Services**: 20 requests per minute per user
- **File Upload**: 10 requests per minute per user

## 📊 Response Format

All successful responses follow this format:

```json
{
  "success": true,
  "message": "Operation completed successfully",
  "data": {
    // Response data here
  },
  "meta": {
    "timestamp": "2024-01-15T10:30:00Z",
    "request_id": "req_123456789"
  }
}
```

## 🧪 Testing the API

### Using cURL

```bash
# Register a new user
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "name": "Test User",
    "age": 25,
    "gender": "male",
    "height": 175,
    "weight": 70
  }'

# Login
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

### Using Postman

1. Import the API collection
2. Set the base URL to `http://localhost:5000/api`
3. Configure authentication with JWT token
4. Test the endpoints

---

**Need help?** Check the [README.md](README.md) or create an issue on GitHub.
