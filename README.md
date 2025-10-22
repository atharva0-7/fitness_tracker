# 🏋️‍♀️ FitAI - AI Fitness & Nutrition Tracker

A comprehensive health and fitness application that generates personalized workout and meal plans using AI technology. Built with Flutter frontend and Flask backend, featuring Google Gemini AI integration for intelligent recommendations.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)

## ✨ Features

### 🎯 **AI-Powered Personalization**
- **Smart Workout Plans**: AI-generated workout routines based on your goals, fitness level, and preferences
- **Personalized Meal Plans**: Custom meal plans with dietary preferences and nutritional requirements
- **Voice Assistant**: Chat with AI for fitness guidance and nutrition advice
- **Progress Insights**: Intelligent analysis of your fitness journey

### 📊 **Comprehensive Tracking**
- **Fitness Tracking**: Workouts, exercises, sets, reps, and progress monitoring
- **Nutrition Logging**: Calories, macros, meal logging, and water intake tracking
- **Progress Analytics**: Weight, BMI, body measurements, and goal tracking
- **Data Visualization**: Beautiful charts and graphs for progress analysis

### 🎨 **Beautiful UI/UX**
- **Modern Design**: Material Design 3 with custom gradients and animations
- **Responsive Layout**: Works perfectly on all screen sizes
- **Smooth Animations**: Delightful micro-interactions and transitions
- **Dark/Light Theme**: Automatic theme switching support

## 🚀 Quick Start

### Prerequisites

- **Flutter SDK** (3.7.0 or higher)
- **Python** (3.8 or higher)
- **Node.js** (for web development)
- **Git**

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/fitness_app.git
cd fitness_app
```

### 2. Backend Setup (Flask)

```bash
# Navigate to backend directory
cd backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Set up environment variables
cp env.example .env
```

#### Configure Environment Variables

Edit the `.env` file with your configuration:

```env
# Flask Configuration
FLASK_APP=app.py
FLASK_ENV=development
SECRET_KEY=your-secret-key-here

# Database Configuration
DATABASE_URL=sqlite:///fitness_tracker.db

# Google Gemini AI Configuration
GEMINI_API_KEY=your-gemini-api-key-here

# Firebase Configuration (Optional)
FIREBASE_PROJECT_ID=your-firebase-project-id
FIREBASE_PRIVATE_KEY=your-firebase-private-key
FIREBASE_CLIENT_EMAIL=your-firebase-client-email

# JWT Configuration
JWT_SECRET_KEY=your-jwt-secret-key
JWT_ACCESS_TOKEN_EXPIRES=3600
```

#### Get Your Gemini API Key

1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy the generated API key
5. Paste it in your `.env` file

#### Run the Backend

```bash
# Initialize database
python -c "from app import create_app, db; app = create_app(); app.app_context().push(); db.create_all()"

# Start the Flask server
python app.py
```

The backend will be available at `http://localhost:5000`

### 3. Frontend Setup (Flutter)

```bash
# Navigate to frontend directory
cd ../frontend

# Install dependencies
flutter pub get

# Run the app
flutter run
```

#### Available Platforms

- **Web**: `flutter run -d chrome`
- **Android**: `flutter run -d android`
- **iOS**: `flutter run -d ios`
- **macOS**: `flutter run -d macos`
- **Windows**: `flutter run -d windows`

## 📱 App Structure

### Frontend (Flutter)
```
frontend/
├── lib/
│   ├── core/                 # Core utilities and constants
│   │   ├── constants/        # App constants and colors
│   │   └── utils/           # Utility functions
│   ├── data/                # Data layer
│   │   ├── models/          # Data models
│   │   └── data_source/     # Local and remote data sources
│   ├── domain/              # Business logic layer
│   │   ├── entity/          # Domain entities
│   │   ├── repo/            # Repository interfaces
│   │   └── usecase/         # Use cases
│   ├── presentation/        # UI layer
│   │   └── features/        # Feature-based UI components
│   └── main.dart            # App entry point
├── assets/                  # Images, icons, animations
└── pubspec.yaml            # Dependencies and configuration
```

### Backend (Flask)
```
backend/
├── app/
│   ├── api/                # API routes
│   ├── models/             # Database models
│   ├── services/           # Business logic services
│   └── utils/              # Utility functions
├── migrations/             # Database migrations
├── requirements.txt        # Python dependencies
└── app.py                 # Flask application entry point
```

## 🔧 Configuration

### API Endpoints

The backend provides the following main API endpoints:

- **Authentication**: `/api/auth/register`, `/api/auth/login`
- **User Management**: `/api/user/profile`, `/api/user/goals`
- **Workouts**: `/api/workouts/generate`, `/api/workouts/complete`
- **Meals**: `/api/meals/generate`, `/api/meals/log`
- **Progress**: `/api/progress/track`, `/api/progress/analytics`
- **AI Services**: `/api/ai/chat`, `/api/ai/voice`

### Database Schema

The app uses SQLAlchemy with the following main models:

- **User**: Profile information, goals, preferences
- **Workout**: Exercise routines, plans, sessions
- **Meal**: Meal plans, nutrition tracking
- **Progress**: Weight, measurements, achievements

## 🎨 Customization

### Colors and Themes

Edit `frontend/lib/core/constants/app_colors.dart` to customize the app's color scheme:

```dart
class AppColors {
  static const Color primary = Color(0xFF6C5CE7);
  static const Color secondary = Color(0xFF00CEC9);
  // ... more colors
}
```

### Adding New Features

1. **Create Entity**: Define the domain model in `domain/entity/`
2. **Create Repository**: Define the interface in `domain/repo/`
3. **Implement Repository**: Create implementation in `data/repo_impl/`
4. **Create Use Case**: Add business logic in `domain/usecase/`
5. **Create UI**: Build the presentation layer in `presentation/features/`

## 🧪 Testing

### Frontend Testing

```bash
cd frontend

# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Run with coverage
flutter test --coverage
```

### Backend Testing

```bash
cd backend

# Activate virtual environment
source venv/bin/activate

# Run tests
python -m pytest tests/

# Run with coverage
python -m pytest --cov=app tests/
```

## 📦 Building for Production

### Frontend Build

```bash
cd frontend

# Build for web
flutter build web

# Build for Android
flutter build apk --release

# Build for iOS
flutter build ios --release
```

### Backend Deployment

```bash
cd backend

# Install production dependencies
pip install gunicorn

# Run with Gunicorn
gunicorn -w 4 -b 0.0.0.0:5000 app:app
```

## 🔐 Security Considerations

- **API Keys**: Never commit API keys to version control
- **JWT Tokens**: Use secure token storage and rotation
- **Input Validation**: Validate all user inputs
- **HTTPS**: Always use HTTPS in production
- **Database Security**: Use connection pooling and prepared statements

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Google Gemini AI** for intelligent recommendations
- **Flutter Team** for the amazing framework
- **Firebase** for backend services
- **Material Design** for beautiful UI components

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/yourusername/fitness_app/issues) page
2. Create a new issue with detailed information
3. Contact the development team

## 🚀 Roadmap

- [ ] **Social Features**: Share workouts and progress with friends
- [ ] **Wearable Integration**: Connect with fitness trackers and smartwatches
- [ ] **Advanced Analytics**: Machine learning insights and predictions
- [ ] **Offline Mode**: Full functionality without internet connection
- [ ] **Multi-language Support**: Internationalization for global users

---

**Made with ❤️ for fitness enthusiasts worldwide**

*Transform your fitness journey with AI-powered personalization!*# fitness_tracker
