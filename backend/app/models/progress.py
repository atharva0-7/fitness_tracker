from app import db
from datetime import datetime, date
import json

class Progress(db.Model):
    __tablename__ = 'progress'
    
    id = db.Column(db.String(50), primary_key=True)
    user_id = db.Column(db.String(50), db.ForeignKey('users.id'), nullable=False)
    date = db.Column(db.Date, nullable=False)
    weight = db.Column(db.Float)
    body_fat = db.Column(db.Float)
    muscle_mass = db.Column(db.Float)
    water_percentage = db.Column(db.Float)
    bone_density = db.Column(db.Float)
    calories_burned = db.Column(db.Integer)
    steps = db.Column(db.Integer)
    distance = db.Column(db.Float)  # in kilometers
    active_minutes = db.Column(db.Integer)
    heart_rate = db.Column(db.Integer)
    notes = db.Column(db.Text)
    images = db.Column(db.Text)  # JSON string of list
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    def set_images(self, images):
        """Set images as JSON string"""
        self.images = json.dumps(images)
    
    def get_images(self):
        """Get images as list"""
        if self.images:
            return json.loads(self.images)
        return []
    
    def to_dict(self):
        """Convert progress to dictionary"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'date': self.date.isoformat() if self.date else None,
            'weight': self.weight,
            'body_fat': self.body_fat,
            'muscle_mass': self.muscle_mass,
            'water_percentage': self.water_percentage,
            'bone_density': self.bone_density,
            'calories_burned': self.calories_burned,
            'steps': self.steps,
            'distance': self.distance,
            'active_minutes': self.active_minutes,
            'heart_rate': self.heart_rate,
            'notes': self.notes,
            'images': self.get_images(),
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }
    
    def __repr__(self):
        return f'<Progress {self.user_id} - {self.date}>'

class WeightProgress(db.Model):
    __tablename__ = 'weight_progress'
    
    id = db.Column(db.String(50), primary_key=True)
    user_id = db.Column(db.String(50), db.ForeignKey('users.id'), nullable=False)
    date = db.Column(db.Date, nullable=False)
    weight = db.Column(db.Float, nullable=False)
    body_fat = db.Column(db.Float)
    muscle_mass = db.Column(db.Float)
    notes = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    def to_dict(self):
        """Convert weight progress to dictionary"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'date': self.date.isoformat() if self.date else None,
            'weight': self.weight,
            'body_fat': self.body_fat,
            'muscle_mass': self.muscle_mass,
            'notes': self.notes,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }
    
    def __repr__(self):
        return f'<WeightProgress {self.user_id} - {self.date}>'

class BmiProgress(db.Model):
    __tablename__ = 'bmi_progress'
    
    id = db.Column(db.String(50), primary_key=True)
    user_id = db.Column(db.String(50), db.ForeignKey('users.id'), nullable=False)
    date = db.Column(db.Date, nullable=False)
    weight = db.Column(db.Float, nullable=False)
    height = db.Column(db.Float, nullable=False)  # in cm
    bmi = db.Column(db.Float, nullable=False)
    category = db.Column(db.String(50), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    @staticmethod
    def calculate_bmi(weight, height):
        """Calculate BMI"""
        height_m = height / 100
        return round(weight / (height_m ** 2), 2)
    
    @staticmethod
    def get_bmi_category(bmi):
        """Get BMI category"""
        if bmi < 18.5:
            return 'Underweight'
        elif bmi < 25:
            return 'Normal weight'
        elif bmi < 30:
            return 'Overweight'
        else:
            return 'Obese'
    
    def to_dict(self):
        """Convert BMI progress to dictionary"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'date': self.date.isoformat() if self.date else None,
            'weight': self.weight,
            'height': self.height,
            'bmi': self.bmi,
            'category': self.category,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }
    
    def __repr__(self):
        return f'<BmiProgress {self.user_id} - {self.date}>'

class CalorieProgress(db.Model):
    __tablename__ = 'calorie_progress'
    
    id = db.Column(db.String(50), primary_key=True)
    user_id = db.Column(db.String(50), db.ForeignKey('users.id'), nullable=False)
    date = db.Column(db.Date, nullable=False)
    calories_consumed = db.Column(db.Integer, nullable=False)
    calories_burned = db.Column(db.Integer, nullable=False)
    target_calories = db.Column(db.Integer, nullable=False)
    net_calories = db.Column(db.Integer, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    @property
    def calories_progress(self):
        """Calculate calories progress percentage"""
        if self.target_calories > 0:
            return round(self.calories_consumed / self.target_calories, 2)
        return 0
    
    @property
    def remaining_calories(self):
        """Calculate remaining calories"""
        return self.target_calories - self.calories_consumed
    
    def to_dict(self):
        """Convert calorie progress to dictionary"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'date': self.date.isoformat() if self.date else None,
            'calories_consumed': self.calories_consumed,
            'calories_burned': self.calories_burned,
            'target_calories': self.target_calories,
            'net_calories': self.net_calories,
            'calories_progress': self.calories_progress,
            'remaining_calories': self.remaining_calories,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }
    
    def __repr__(self):
        return f'<CalorieProgress {self.user_id} - {self.date}>'

class WorkoutProgress(db.Model):
    __tablename__ = 'workout_progress'
    
    id = db.Column(db.String(50), primary_key=True)
    user_id = db.Column(db.String(50), db.ForeignKey('users.id'), nullable=False)
    date = db.Column(db.Date, nullable=False)
    workouts_completed = db.Column(db.Integer, nullable=False)
    total_workouts = db.Column(db.Integer, nullable=False)
    total_duration = db.Column(db.Integer, nullable=False)  # in minutes
    total_calories_burned = db.Column(db.Integer, nullable=False)
    workout_types = db.Column(db.Text)  # JSON string of list
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    def set_workout_types(self, types):
        """Set workout types as JSON string"""
        self.workout_types = json.dumps(types)
    
    def get_workout_types(self):
        """Get workout types as list"""
        if self.workout_types:
            return json.loads(self.workout_types)
        return []
    
    @property
    def completion_rate(self):
        """Calculate completion rate"""
        if self.total_workouts > 0:
            return round(self.workouts_completed / self.total_workouts, 2)
        return 0
    
    def to_dict(self):
        """Convert workout progress to dictionary"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'date': self.date.isoformat() if self.date else None,
            'workouts_completed': self.workouts_completed,
            'total_workouts': self.total_workouts,
            'total_duration': self.total_duration,
            'total_calories_burned': self.total_calories_burned,
            'workout_types': self.get_workout_types(),
            'completion_rate': self.completion_rate,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }
    
    def __repr__(self):
        return f'<WorkoutProgress {self.user_id} - {self.date}>'

class Goal(db.Model):
    __tablename__ = 'goals'
    
    id = db.Column(db.String(50), primary_key=True)
    user_id = db.Column(db.String(50), db.ForeignKey('users.id'), nullable=False)
    type = db.Column(db.String(50), nullable=False)  # weight, bmi, calories, workouts, etc.
    title = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text)
    target_value = db.Column(db.Float, nullable=False)
    current_value = db.Column(db.Float, nullable=False)
    unit = db.Column(db.String(20), nullable=False)
    target_date = db.Column(db.Date, nullable=False)
    is_completed = db.Column(db.Boolean, default=False)
    is_active = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    @property
    def progress(self):
        """Calculate progress percentage"""
        if self.target_value > 0:
            return round(self.current_value / self.target_value, 2)
        return 0
    
    @property
    def days_remaining(self):
        """Calculate days remaining"""
        today = date.today()
        if self.target_date > today:
            return (self.target_date - today).days
        return 0
    
    @property
    def is_overdue(self):
        """Check if goal is overdue"""
        today = date.today()
        return today > self.target_date and not self.is_completed
    
    def to_dict(self):
        """Convert goal to dictionary"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'type': self.type,
            'title': self.title,
            'description': self.description,
            'target_value': self.target_value,
            'current_value': self.current_value,
            'unit': self.unit,
            'target_date': self.target_date.isoformat() if self.target_date else None,
            'is_completed': self.is_completed,
            'is_active': self.is_active,
            'progress': self.progress,
            'days_remaining': self.days_remaining,
            'is_overdue': self.is_overdue,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }
    
    def __repr__(self):
        return f'<Goal {self.title}>'
