from app import db
from datetime import datetime
import json

class Meal(db.Model):
    __tablename__ = 'meals'
    
    id = db.Column(db.String(50), primary_key=True)
    name = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text)
    type = db.Column(db.String(50), nullable=False)  # breakfast, lunch, dinner, snack
    image_url = db.Column(db.String(500))
    calories = db.Column(db.Integer, nullable=False)
    protein = db.Column(db.Integer, nullable=False)  # in grams
    carbs = db.Column(db.Integer, nullable=False)  # in grams
    fat = db.Column(db.Integer, nullable=False)  # in grams
    fiber = db.Column(db.Integer, default=0)  # in grams
    sugar = db.Column(db.Integer, default=0)  # in grams
    sodium = db.Column(db.Integer, default=0)  # in mg
    ingredients = db.Column(db.Text)  # JSON string of list
    instructions = db.Column(db.Text)  # JSON string of list
    prep_time = db.Column(db.Integer, nullable=False)  # in minutes
    cook_time = db.Column(db.Integer, nullable=False)  # in minutes
    servings = db.Column(db.Integer, default=1)
    dietary_tags = db.Column(db.Text)  # JSON string of list
    allergens = db.Column(db.Text)  # JSON string of list
    is_custom = db.Column(db.Boolean, default=False)
    created_by = db.Column(db.String(50), db.ForeignKey('users.id'))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    nutrition_logs = db.relationship('NutritionLog', backref='meal', lazy='dynamic')
    
    def set_ingredients(self, ingredients):
        """Set ingredients as JSON string"""
        self.ingredients = json.dumps(ingredients)
    
    def get_ingredients(self):
        """Get ingredients as list"""
        if self.ingredients:
            return json.loads(self.ingredients)
        return []
    
    def set_instructions(self, instructions):
        """Set instructions as JSON string"""
        self.instructions = json.dumps(instructions)
    
    def get_instructions(self):
        """Get instructions as list"""
        if self.instructions:
            return json.loads(self.instructions)
        return []
    
    def set_dietary_tags(self, tags):
        """Set dietary tags as JSON string"""
        self.dietary_tags = json.dumps(tags)
    
    def get_dietary_tags(self):
        """Get dietary tags as list"""
        if self.dietary_tags:
            return json.loads(self.dietary_tags)
        return []
    
    def set_allergens(self, allergens):
        """Set allergens as JSON string"""
        self.allergens = json.dumps(allergens)
    
    def get_allergens(self):
        """Get allergens as list"""
        if self.allergens:
            return json.loads(self.allergens)
        return []
    
    @property
    def protein_percentage(self):
        """Calculate protein percentage of total calories"""
        if self.calories > 0:
            return round((self.protein * 4) / self.calories * 100, 2)
        return 0
    
    @property
    def carbs_percentage(self):
        """Calculate carbs percentage of total calories"""
        if self.calories > 0:
            return round((self.carbs * 4) / self.calories * 100, 2)
        return 0
    
    @property
    def fat_percentage(self):
        """Calculate fat percentage of total calories"""
        if self.calories > 0:
            return round((self.fat * 9) / self.calories * 100, 2)
        return 0
    
    def to_dict(self):
        """Convert meal to dictionary"""
        return {
            'id': self.id,
            'name': self.name,
            'description': self.description,
            'type': self.type,
            'image_url': self.image_url,
            'calories': self.calories,
            'protein': self.protein,
            'carbs': self.carbs,
            'fat': self.fat,
            'fiber': self.fiber,
            'sugar': self.sugar,
            'sodium': self.sodium,
            'ingredients': self.get_ingredients(),
            'instructions': self.get_instructions(),
            'prep_time': self.prep_time,
            'cook_time': self.cook_time,
            'servings': self.servings,
            'dietary_tags': self.get_dietary_tags(),
            'allergens': self.get_allergens(),
            'is_custom': self.is_custom,
            'created_by': self.created_by,
            'protein_percentage': self.protein_percentage,
            'carbs_percentage': self.carbs_percentage,
            'fat_percentage': self.fat_percentage,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }
    
    def __repr__(self):
        return f'<Meal {self.name}>'

class MealPlan(db.Model):
    __tablename__ = 'meal_plans'
    
    id = db.Column(db.String(50), primary_key=True)
    name = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text)
    user_id = db.Column(db.String(50), db.ForeignKey('users.id'), nullable=False)
    days_data = db.Column(db.Text)  # JSON string of days
    total_days = db.Column(db.Integer, nullable=False)
    target_calories = db.Column(db.Integer, nullable=False)
    dietary_preference = db.Column(db.String(50), nullable=False)
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
            'total_days': self.total_days,
            'target_calories': self.target_calories,
            'dietary_preference': self.dietary_preference,
            'is_active': self.is_active,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }
    
    def __repr__(self):
        return f'<MealPlan {self.name}>'

class NutritionLog(db.Model):
    __tablename__ = 'nutrition_logs'
    
    id = db.Column(db.String(50), primary_key=True)
    user_id = db.Column(db.String(50), db.ForeignKey('users.id'), nullable=False)
    meal_id = db.Column(db.String(50), db.ForeignKey('meals.id'), nullable=False)
    meal_name = db.Column(db.String(200), nullable=False)
    meal_type = db.Column(db.String(50), nullable=False)
    quantity = db.Column(db.Float, nullable=False)
    unit = db.Column(db.String(20), nullable=False)  # grams, cups, pieces, etc.
    calories = db.Column(db.Integer, nullable=False)
    protein = db.Column(db.Integer, nullable=False)
    carbs = db.Column(db.Integer, nullable=False)
    fat = db.Column(db.Integer, nullable=False)
    logged_at = db.Column(db.DateTime, default=datetime.utcnow)
    notes = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    def to_dict(self):
        """Convert log to dictionary"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'meal_id': self.meal_id,
            'meal_name': self.meal_name,
            'meal_type': self.meal_type,
            'quantity': self.quantity,
            'unit': self.unit,
            'calories': self.calories,
            'protein': self.protein,
            'carbs': self.carbs,
            'fat': self.fat,
            'logged_at': self.logged_at.isoformat() if self.logged_at else None,
            'notes': self.notes,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }
    
    def __repr__(self):
        return f'<NutritionLog {self.meal_name}>'
