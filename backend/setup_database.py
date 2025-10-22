#!/usr/bin/env python3
"""
Database setup script for FitAI Backend
"""

import os
import sys
from datetime import datetime
import uuid

# Add the current directory to Python path
sys.path.append(os.path.dirname(__file__))

# Import Flask app and database
import sys
import os
sys.path.append(os.path.dirname(__file__))

# Import the Flask app from the parent directory
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
from app import app, db

def setup_database():
    """Initialize the database with tables and sample data"""
    print("🚀 Setting up FitAI Database...")
    
    with app.app_context():
        # Create all tables
        print("📊 Creating database tables...")
        db.create_all()
        print("✅ Database tables created successfully!")
        
        # Check if we already have data
        try:
            # Try to query the users table
            result = db.session.execute(db.text("SELECT COUNT(*) FROM users")).scalar()
            if result and result > 0:
                print("ℹ️  Database already has data, skipping sample data creation")
                return
        except Exception:
            # Table doesn't exist yet, continue with setup
            pass
        
        print("✅ Database setup complete!")
        print("📝 Note: Sample data creation requires the models to be properly imported")
        print("💡 Run the Flask app to test the database connection")

def check_database_status():
    """Check the current status of the database"""
    print("🔍 Checking database status...")
    
    with app.app_context():
        try:
            # Check if tables exist by querying the database directly
            result = db.session.execute(db.text("SELECT name FROM sqlite_master WHERE type='table'")).fetchall()
            tables = [row[0] for row in result]
            
            print(f"📊 Database Status:")
            print(f"   📋 Tables found: {len(tables)}")
            for table in tables:
                count_result = db.session.execute(db.text(f"SELECT COUNT(*) FROM {table}")).scalar()
                print(f"   📊 {table}: {count_result} records")
            
            if tables:
                print("✅ Database is set up and accessible")
            else:
                print("⚠️  No tables found - run setup to create tables")
                
        except Exception as e:
            print(f"❌ Database error: {e}")

if __name__ == '__main__':
    import argparse
    
    parser = argparse.ArgumentParser(description='FitAI Database Setup')
    parser.add_argument('--setup', action='store_true', help='Set up the database with sample data')
    parser.add_argument('--check', action='store_true', help='Check database status')
    parser.add_argument('--reset', action='store_true', help='Reset database (WARNING: deletes all data)')
    
    args = parser.parse_args()
    
    if args.reset:
        print("⚠️  WARNING: This will delete all data!")
        confirm = input("Are you sure? Type 'yes' to continue: ")
        if confirm.lower() == 'yes':
            with app.app_context():
                db.drop_all()
                print("🗑️  Database reset complete")
        else:
            print("❌ Reset cancelled")
    
    if args.setup:
        setup_database()
    
    if args.check or not any([args.setup, args.reset]):
        check_database_status()
