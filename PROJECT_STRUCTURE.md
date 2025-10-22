# FitAI Project Structure

## 📁 Directory Overview

```
fitness_app/
├── frontend/                 # Flutter mobile application
│   ├── lib/
│   │   ├── core/            # Core functionality
│   │   │   ├── auto_route/  # Navigation routes
│   │   │   ├── constants/   # App constants, colors, themes
│   │   │   ├── di/          # Dependency injection
│   │   │   ├── network_layer/ # API client and networking
│   │   │   └── utils/       # Utility functions
│   │   ├── data/            # Data layer
│   │   │   ├── data_source/ # Local and remote data sources
│   │   │   ├── models/      # Data models
│   │   │   └── repo_impl/   # Repository implementations
│   │   ├── domain/          # Business logic layer
│   │   │   ├── entity/      # Business entities
│   │   │   ├── repo/        # Repository interfaces
│   │   │   └── usecase/     # Business logic use cases
│   │   └── presentation/    # UI layer
│   │       └── features/    # Feature-based UI
│   │           ├── auth/    # Authentication
│   │           ├── profile/ # User profile
│   │           ├── workout/ # Workout management
│   │           ├── meal/    # Meal planning
│   │           ├── nutrition/ # Nutrition tracking
│   │           ├── progress/ # Progress tracking
│   │           └── voice_assistant/ # Voice interaction
│   ├── assets/              # App assets
│   │   ├── images/          # Images and photos
│   │   ├── icons/           # App icons
│   │   ├── animations/      # Lottie animations
│   │   └── fonts/           # Custom fonts
│   ├── android/             # Android-specific code
│   ├── ios/                 # iOS-specific code
│   ├── test/                # Test files
│   ├── pubspec.yaml         # Flutter dependencies
│   └── setup.sh             # Setup script
├── backend/                 # Flask API server
│   ├── app/
│   │   ├── api/             # API routes
│   │   │   ├── auth.py      # Authentication endpoints
│   │   │   ├── user.py      # User management
│   │   │   ├── workout.py   # Workout endpoints
│   │   │   ├── meal.py      # Meal endpoints
│   │   │   ├── nutrition.py # Nutrition tracking
│   │   │   ├── progress.py  # Progress tracking
│   │   │   └── ai.py        # AI endpoints
│   │   ├── models/          # Database models
│   │   │   ├── user.py      # User models
│   │   │   ├── workout.py   # Workout models
│   │   │   ├── meal.py      # Meal models
│   │   │   └── progress.py  # Progress models
│   │   ├── services/        # Business logic services
│   │   │   └── ai_service.py # AI integration service
│   │   └── utils/           # Utility functions
│   ├── tests/               # Test files
│   ├── migrations/          # Database migrations
│   ├── requirements.txt     # Python dependencies
│   ├── app.py              # Flask application
│   ├── setup.py            # Setup script
│   └── env.example         # Environment variables template
├── docs/                    # Documentation
├── README.md               # Project overview
└── PROJECT_STRUCTURE.md    # This file
```

## 🏗️ Architecture Layers

### Frontend (Flutter)

#### Core Layer
- **Constants**: App-wide constants, colors, themes, and configuration
- **Network Layer**: API client, HTTP interceptors, and network utilities
- **Dependency Injection**: Service locator and dependency management
- **Utils**: Helper functions and utilities

#### Data Layer
- **Data Sources**: Local (Hive) and remote (API) data sources
- **Models**: Data transfer objects and serialization
- **Repository Implementations**: Concrete implementations of domain repositories

#### Domain Layer
- **Entities**: Business objects and domain models
- **Repositories**: Abstract interfaces for data access
- **Use Cases**: Business logic and application rules

#### Presentation Layer
- **Features**: Feature-based UI organization
- **Screens**: UI screens and pages
- **Blocs**: State management and business logic
- **Widgets**: Reusable UI components

### Backend (Flask)

#### API Layer
- **Routes**: RESTful API endpoints
- **Authentication**: JWT-based authentication
- **Validation**: Request/response validation

#### Models Layer
- **Database Models**: SQLAlchemy ORM models
- **Relationships**: Model associations and foreign keys
- **Serialization**: JSON serialization methods

#### Services Layer
- **Business Logic**: Core application logic
- **AI Integration**: Google Gemini AI service
- **External APIs**: Third-party service integrations

## 🔄 Data Flow

### Frontend Data Flow
1. **UI** → **Bloc** → **Use Case** → **Repository** → **Data Source**
2. **API Response** → **Model** → **Entity** → **Bloc** → **UI**

### Backend Data Flow
1. **API Request** → **Route** → **Service** → **Model** → **Database**
2. **Database** → **Model** → **Service** → **Route** → **API Response**

## 📱 Feature Organization

### Authentication
- User registration and login
- Profile management
- Password reset
- Social authentication

### Workout Management
- Workout plan generation
- Exercise library
- Workout tracking
- Progress monitoring

### Meal Planning
- Meal plan generation
- Recipe database
- Nutrition tracking
- Dietary preferences

### Progress Tracking
- Weight tracking
- BMI monitoring
- Calorie tracking
- Goal setting

### AI Assistant
- Voice interaction
- Personalized recommendations
- Health insights
- Progress analysis

## 🛠️ Development Workflow

### Frontend Development
1. Create feature in `presentation/features/`
2. Define entities in `domain/entity/`
3. Create repository interfaces in `domain/repo/`
4. Implement use cases in `domain/usecase/`
5. Create data models in `data/models/`
6. Implement repositories in `data/repo_impl/`
7. Add UI screens and widgets

### Backend Development
1. Define database models in `models/`
2. Create API routes in `api/`
3. Implement business logic in `services/`
4. Add database migrations
5. Write tests

## 📦 Dependencies

### Frontend Dependencies
- **State Management**: flutter_bloc, equatable
- **Navigation**: auto_route, go_router
- **Networking**: dio, retrofit
- **Local Storage**: hive, shared_preferences
- **Firebase**: firebase_core, firebase_auth, cloud_firestore
- **UI**: google_fonts, lottie, fl_chart
- **Voice**: speech_to_text, flutter_tts

### Backend Dependencies
- **Web Framework**: Flask, Flask-CORS
- **Database**: SQLAlchemy, Flask-Migrate
- **Authentication**: Flask-JWT-Extended
- **AI Integration**: google-generativeai
- **Background Tasks**: Celery, Redis
- **Testing**: pytest, pytest-flask

## 🚀 Getting Started

### Frontend Setup
```bash
cd frontend
chmod +x setup.sh
./setup.sh
flutter run
```

### Backend Setup
```bash
cd backend
python setup.py
source venv/bin/activate  # On Windows: venv\Scripts\activate
python app.py
```

## 📝 Notes

- This project follows clean architecture principles
- Feature-based organization for better maintainability
- Comprehensive error handling and validation
- Responsive design for all screen sizes
- Offline-first approach with sync capabilities
- AI-powered personalization throughout the app
