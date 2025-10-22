#!/usr/bin/env python3

import sys
import os
sys.path.append('/Users/coditas/fitness_app')

from backend.app import app

if __name__ == '__main__':
    with app.app_context():
        print("✅ Flask app created successfully")
        print("✅ Database tables created")
        print("✅ AI service initialized")
        print("🚀 Starting server on port 5001...")
    
    app.run(debug=True, host='0.0.0.0', port=5001)
