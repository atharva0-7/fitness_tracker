#!/usr/bin/env python3
"""
Test script to debug import issues
"""

import sys
import os

# Add current directory to Python path
sys.path.append(os.path.dirname(__file__))

print("🔍 Testing imports...")
print(f"Current directory: {os.getcwd()}")
print(f"Python path: {sys.path}")

# Test model imports
try:
    from app.models.user import User
    print("✅ User model imported successfully")
except ImportError as e:
    print(f"❌ User model import failed: {e}")

try:
    from app.models.workout import Workout
    print("✅ Workout model imported successfully")
except ImportError as e:
    print(f"❌ Workout model import failed: {e}")

# Test API imports
try:
    from app.api.auth import auth_bp
    print("✅ Auth API imported successfully")
except ImportError as e:
    print(f"❌ Auth API import failed: {e}")

# Test Flask app
try:
    from app import app, db
    print("✅ Flask app imported successfully")
    
    # Test database creation
    with app.app_context():
        db.create_all()
        print("✅ Database tables created")
        
        # Check tables
        from sqlalchemy import inspect
        inspector = inspect(db.engine)
        tables = inspector.get_table_names()
        print(f"📊 Tables found: {tables}")
        
except ImportError as e:
    print(f"❌ Flask app import failed: {e}")
