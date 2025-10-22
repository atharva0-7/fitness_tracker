from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_jwt_extended import JWTManager
from datetime import timedelta
import os
import sys
from dotenv import load_dotenv

# Add current directory to Python path for imports
sys.path.append(os.path.dirname(__file__))

# Load environment variables
load_dotenv()

# Initialize Flask app
app = Flask(__name__)

# Configuration
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', 'your-secret-key-here')
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URL', 'sqlite:///fitness_tracker.db')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['JWT_SECRET_KEY'] = os.getenv('JWT_SECRET_KEY', 'jwt-secret-string')
app.config['JWT_ACCESS_TOKEN_EXPIRES'] = timedelta(days=7)

# Initialize extensions
db = SQLAlchemy(app)
migrate = Migrate(app, db)
jwt = JWTManager(app)
CORS(app)

# Import models
try:
    from app.models.user import User
    from app.models.workout import Workout, Exercise, WorkoutSession
    from app.models.meal import Meal, MealPlan, NutritionLog
    from app.models.progress import Progress, WeightProgress, BmiProgress
    print("✅ Models loaded successfully!")
except ImportError as e:
    # If running from parent directory, models might not be available
    print(f"⚠️ Models not available - running in minimal mode: {e}")

# Import API routes
try:
    from app.api.auth import auth_bp
    from app.api.user import user_bp
    from app.api.workout import workout_bp
    from app.api.meal import meal_bp
    from app.api.nutrition import nutrition_bp
    from app.api.progress import progress_bp
    from app.api.ai_simple import ai_bp
    print("✅ API routes loaded successfully!")
except ImportError as e:
    print(f"⚠️ Some API routes not available - running in minimal mode: {e}")
    # Create minimal blueprints
    from flask import Blueprint
    auth_bp = Blueprint('auth', __name__)
    user_bp = Blueprint('user', __name__)
    workout_bp = Blueprint('workout', __name__)
    meal_bp = Blueprint('meal', __name__)
    nutrition_bp = Blueprint('nutrition', __name__)
    progress_bp = Blueprint('progress', __name__)
    ai_bp = Blueprint('ai', __name__)

# Register blueprints
app.register_blueprint(auth_bp, url_prefix='/api/auth')
app.register_blueprint(user_bp, url_prefix='/api/user')
app.register_blueprint(workout_bp, url_prefix='/api/workouts')
app.register_blueprint(meal_bp, url_prefix='/api/meals')
app.register_blueprint(nutrition_bp, url_prefix='/api/nutrition')
app.register_blueprint(progress_bp, url_prefix='/api/progress')
app.register_blueprint(ai_bp, url_prefix='/api/ai')

# Error handlers
@app.errorhandler(404)
def not_found(error):
    return jsonify({'error': 'Not found'}), 404

@app.errorhandler(500)
def internal_error(error):
    return jsonify({'error': 'Internal server error'}), 500

@app.errorhandler(400)
def bad_request(error):
    return jsonify({'error': 'Bad request'}), 400

@app.errorhandler(401)
def unauthorized(error):
    return jsonify({'error': 'Unauthorized'}), 401

@app.errorhandler(403)
def forbidden(error):
    return jsonify({'error': 'Forbidden'}), 403

# Health check endpoint
@app.route('/api/health')
def health_check():
    return jsonify({
        'status': 'healthy',
        'message': 'FitAI API is running',
        'version': '1.0.0'
    })

# Root endpoint
@app.route('/')
def index():
    return jsonify({
        'message': 'Welcome to FitAI API',
        'version': '1.0.0',
        'docs': '/api/docs'
    })

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True, host='0.0.0.0', port=5001)
