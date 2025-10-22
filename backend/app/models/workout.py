from app import db
from datetime import datetime
import json

class Workout(db.Model):
    __tablename__ = 'workouts'
    
    id = db.Column(db.String(50), primary_key=True)
    name = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text)
    type = db.Column(db.String(50), nullable=False)  # cardio, strength, yoga, etc.
    difficulty = db.Column(db.String(20), nullable=False)  # beginner, intermediate, advanced
    body_parts = db.Column(db.Text)  # JSON string of list
    duration = db.Column(db.Integer, nullable=False)  # in minutes
    calories_burned = db.Column(db.Integer, default=0)
    image_url = db.Column(db.String(500))
    video_url = db.Column(db.String(500))
    is_custom = db.Column(db.Boolean, default=False)
    created_by = db.Column(db.String(50), db.ForeignKey('users.id'))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    exercises = db.relationship('Exercise', backref='workout', lazy='dynamic', cascade='all, delete-orphan')
    sessions = db.relationship('WorkoutSession', backref='workout', lazy='dynamic')
    
    def set_body_parts(self, body_parts):
        """Set body parts as JSON string"""
        self.body_parts = json.dumps(body_parts)
    
    def get_body_parts(self):
        """Get body parts as list"""
        if self.body_parts:
            return json.loads(self.body_parts)
        return []
    
    def to_dict(self):
        """Convert workout to dictionary"""
        return {
            'id': self.id,
            'name': self.name,
            'description': self.description,
            'type': self.type,
            'difficulty': self.difficulty,
            'body_parts': self.get_body_parts(),
            'duration': self.duration,
            'calories_burned': self.calories_burned,
            'image_url': self.image_url,
            'video_url': self.video_url,
            'is_custom': self.is_custom,
            'created_by': self.created_by,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
            'exercises': [exercise.to_dict() for exercise in self.exercises]
        }
    
    def __repr__(self):
        return f'<Workout {self.name}>'

class Exercise(db.Model):
    __tablename__ = 'exercises'
    
    id = db.Column(db.String(50), primary_key=True)
    workout_id = db.Column(db.String(50), db.ForeignKey('workouts.id'), nullable=False)
    name = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text)
    category = db.Column(db.String(50), nullable=False)  # strength, cardio, flexibility, etc.
    image_url = db.Column(db.String(500))
    video_url = db.Column(db.String(500))
    instructions = db.Column(db.Text)  # JSON string of list
    tips = db.Column(db.Text)  # JSON string of list
    muscles = db.Column(db.Text)  # JSON string of list
    equipment = db.Column(db.String(100), nullable=False)
    exercise_type = db.Column(db.String(50), nullable=False)  # strength, cardio, flexibility, etc.
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    def set_instructions(self, instructions):
        """Set instructions as JSON string"""
        self.instructions = json.dumps(instructions)
    
    def get_instructions(self):
        """Get instructions as list"""
        if self.instructions:
            return json.loads(self.instructions)
        return []
    
    def set_tips(self, tips):
        """Set tips as JSON string"""
        self.tips = json.dumps(tips)
    
    def get_tips(self):
        """Get tips as list"""
        if self.tips:
            return json.loads(self.tips)
        return []
    
    def set_muscles(self, muscles):
        """Set muscles as JSON string"""
        self.muscles = json.dumps(muscles)
    
    def get_muscles(self):
        """Get muscles as list"""
        if self.muscles:
            return json.loads(self.muscles)
        return []
    
    def to_dict(self):
        """Convert exercise to dictionary"""
        return {
            'id': self.id,
            'workout_id': self.workout_id,
            'name': self.name,
            'description': self.description,
            'category': self.category,
            'image_url': self.image_url,
            'video_url': self.video_url,
            'instructions': self.get_instructions(),
            'tips': self.get_tips(),
            'muscles': self.get_muscles(),
            'equipment': self.equipment,
            'exercise_type': self.exercise_type,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }
    
    def __repr__(self):
        return f'<Exercise {self.name}>'

class WorkoutSession(db.Model):
    __tablename__ = 'workout_sessions'
    
    id = db.Column(db.String(50), primary_key=True)
    workout_id = db.Column(db.String(50), db.ForeignKey('workouts.id'), nullable=False)
    user_id = db.Column(db.String(50), db.ForeignKey('users.id'), nullable=False)
    start_time = db.Column(db.DateTime, nullable=False)
    end_time = db.Column(db.DateTime)
    duration = db.Column(db.Integer)  # in minutes
    calories_burned = db.Column(db.Integer, default=0)
    sets_data = db.Column(db.Text)  # JSON string of sets
    notes = db.Column(db.Text)
    status = db.Column(db.String(20), default='not_started')  # not_started, in_progress, completed, paused, cancelled
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    def set_sets_data(self, sets_data):
        """Set sets data as JSON string"""
        self.sets_data = json.dumps(sets_data)
    
    def get_sets_data(self):
        """Get sets data as list"""
        if self.sets_data:
            return json.loads(self.sets_data)
        return []
    
    def calculate_duration(self):
        """Calculate duration in minutes"""
        if self.start_time and self.end_time:
            delta = self.end_time - self.start_time
            self.duration = int(delta.total_seconds() / 60)
        return self.duration
    
    def to_dict(self):
        """Convert session to dictionary"""
        return {
            'id': self.id,
            'workout_id': self.workout_id,
            'user_id': self.user_id,
            'start_time': self.start_time.isoformat() if self.start_time else None,
            'end_time': self.end_time.isoformat() if self.end_time else None,
            'duration': self.duration,
            'calories_burned': self.calories_burned,
            'sets_data': self.get_sets_data(),
            'notes': self.notes,
            'status': self.status,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }
    
    def __repr__(self):
        return f'<WorkoutSession {self.id}>'

class WorkoutPlan(db.Model):
    __tablename__ = 'workout_plans'
    
    id = db.Column(db.String(50), primary_key=True)
    name = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text)
    user_id = db.Column(db.String(50), db.ForeignKey('users.id'), nullable=False)
    days_data = db.Column(db.Text)  # JSON string of days
    total_weeks = db.Column(db.Integer, nullable=False)
    difficulty = db.Column(db.String(20), nullable=False)
    is_active = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    def set_days_data(self, days_data):
        """Set days data as JSON string"""
        self.days_data = json.dumps(days_data)
    
    def get_days_data(self):
        """Get days data as list"""
        if self.days_data:
            return json.loads(self.days_data)
        return []
    
    def to_dict(self):
        """Convert plan to dictionary"""
        return {
            'id': self.id,
            'name': self.name,
            'description': self.description,
            'user_id': self.user_id,
            'days_data': self.get_days_data(),
            'total_weeks': self.total_weeks,
            'difficulty': self.difficulty,
            'is_active': self.is_active,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }
    
    def __repr__(self):
        return f'<WorkoutPlan {self.name}>'
