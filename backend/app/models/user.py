from app import db
from datetime import datetime
from werkzeug.security import generate_password_hash, check_password_hash
from flask_sqlalchemy import SQLAlchemy
import json

class User(db.Model):
    __tablename__ = 'users'
    
    id = db.Column(db.String(50), primary_key=True)
    email = db.Column(db.String(120), unique=True, nullable=False, index=True)
    password_hash = db.Column(db.String(128), nullable=False)
    name = db.Column(db.String(100), nullable=False)
    profile_image_url = db.Column(db.String(500))
    is_active = db.Column(db.Boolean, default=True)
    is_verified = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    last_login = db.Column(db.DateTime)
    
    # Relationships
    goals = db.relationship('UserGoals', backref='user', uselist=False, cascade='all, delete-orphan')
    preferences = db.relationship('UserPreferences', backref='user', uselist=False, cascade='all, delete-orphan')
    workouts = db.relationship('WorkoutSession', backref='user', lazy='dynamic')
    meals = db.relationship('NutritionLog', backref='user', lazy='dynamic')
    progress = db.relationship('Progress', backref='user', lazy='dynamic')
    
    def set_password(self, password):
        """Hash and set the password"""
        self.password_hash = generate_password_hash(password)
    
    def check_password(self, password):
        """Check if the provided password matches the hash"""
        return check_password_hash(self.password_hash, password)
    
    def to_dict(self):
        """Convert user to dictionary"""
        return {
            'id': self.id,
            'email': self.email,
            'name': self.name,
            'profile_image_url': self.profile_image_url,
            'is_active': self.is_active,
            'is_verified': self.is_verified,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
            'last_login': self.last_login.isoformat() if self.last_login else None,
            'goals': self.goals.to_dict() if self.goals else None,
            'preferences': self.preferences.to_dict() if self.preferences else None
        }
    
    def __repr__(self):
        return f'<User {self.email}>'

class UserGoals(db.Model):
    __tablename__ = 'user_goals'
    
    id = db.Column(db.String(50), primary_key=True)
    user_id = db.Column(db.String(50), db.ForeignKey('users.id'), nullable=False)
    fitness_goal = db.Column(db.String(50), nullable=False)  # weight_loss, muscle_gain, etc.
    current_weight = db.Column(db.Float, nullable=False)
    target_weight = db.Column(db.Float, nullable=False)
    height = db.Column(db.Float, nullable=False)  # in cm
    body_type = db.Column(db.String(50), nullable=False)  # ectomorph, mesomorph, endomorph
    target_calories = db.Column(db.Integer, nullable=False)
    target_protein = db.Column(db.Integer, nullable=False)
    target_carbs = db.Column(db.Integer, nullable=False)
    target_fat = db.Column(db.Integer, nullable=False)
    activity_level = db.Column(db.String(50), nullable=False)  # sedentary, light, moderate, active, very_active
    target_date = db.Column(db.Date, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    @property
    def bmi(self):
        """Calculate current BMI"""
        height_m = self.height / 100
        return round(self.current_weight / (height_m ** 2), 2)
    
    @property
    def target_bmi(self):
        """Calculate target BMI"""
        height_m = self.height / 100
        return round(self.target_weight / (height_m ** 2), 2)
    
    def to_dict(self):
        """Convert goals to dictionary"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'fitness_goal': self.fitness_goal,
            'current_weight': self.current_weight,
            'target_weight': self.target_weight,
            'height': self.height,
            'body_type': self.body_type,
            'target_calories': self.target_calories,
            'target_protein': self.target_protein,
            'target_carbs': self.target_carbs,
            'target_fat': self.target_fat,
            'activity_level': self.activity_level,
            'target_date': self.target_date.isoformat() if self.target_date else None,
            'bmi': self.bmi,
            'target_bmi': self.target_bmi,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }
    
    def __repr__(self):
        return f'<UserGoals {self.user_id}>'

class UserPreferences(db.Model):
    __tablename__ = 'user_preferences'
    
    id = db.Column(db.String(50), primary_key=True)
    user_id = db.Column(db.String(50), db.ForeignKey('users.id'), nullable=False)
    dietary_preferences = db.Column(db.Text)  # JSON string of list
    workout_types = db.Column(db.Text)  # JSON string of list
    available_equipment = db.Column(db.Text)  # JSON string of list
    workout_duration = db.Column(db.Integer, default=30)  # in minutes
    difficulty_level = db.Column(db.String(50), default='beginner')
    allergies = db.Column(db.Text)  # JSON string of list
    notifications_enabled = db.Column(db.Boolean, default=True)
    language = db.Column(db.String(10), default='en')
    theme = db.Column(db.String(20), default='light')
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    def set_dietary_preferences(self, preferences):
        """Set dietary preferences as JSON string"""
        self.dietary_preferences = json.dumps(preferences)
    
    def get_dietary_preferences(self):
        """Get dietary preferences as list"""
        if self.dietary_preferences:
            return json.loads(self.dietary_preferences)
        return []
    
    def set_workout_types(self, types):
        """Set workout types as JSON string"""
        self.workout_types = json.dumps(types)
    
    def get_workout_types(self):
        """Get workout types as list"""
        if self.workout_types:
            return json.loads(self.workout_types)
        return []
    
    def set_available_equipment(self, equipment):
        """Set available equipment as JSON string"""
        self.available_equipment = json.dumps(equipment)
    
    def get_available_equipment(self):
        """Get available equipment as list"""
        if self.available_equipment:
            return json.loads(self.available_equipment)
        return []
    
    def set_allergies(self, allergies):
        """Set allergies as JSON string"""
        self.allergies = json.dumps(allergies)
    
    def get_allergies(self):
        """Get allergies as list"""
        if self.allergies:
            return json.loads(self.allergies)
        return []
    
    def to_dict(self):
        """Convert preferences to dictionary"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'dietary_preferences': self.get_dietary_preferences(),
            'workout_types': self.get_workout_types(),
            'available_equipment': self.get_available_equipment(),
            'workout_duration': self.workout_duration,
            'difficulty_level': self.difficulty_level,
            'allergies': self.get_allergies(),
            'notifications_enabled': self.notifications_enabled,
            'language': self.language,
            'theme': self.theme,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }
    
    def __repr__(self):
        return f'<UserPreferences {self.user_id}>'
