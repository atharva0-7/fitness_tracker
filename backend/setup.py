#!/usr/bin/env python3
"""
Setup script for FitAI Backend
"""

import os
import sys
import subprocess
from pathlib import Path

def run_command(command, description):
    """Run a command and handle errors"""
    print(f"🔄 {description}...")
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        print(f"✅ {description} completed successfully")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ {description} failed: {e}")
        print(f"Error output: {e.stderr}")
        return False

def check_python_version():
    """Check if Python version is compatible"""
    if sys.version_info < (3, 8):
        print("❌ Python 3.8 or higher is required")
        sys.exit(1)
    print(f"✅ Python {sys.version_info.major}.{sys.version_info.minor} detected")

def create_virtual_environment():
    """Create virtual environment"""
    if not os.path.exists("venv"):
        return run_command("python -m venv venv", "Creating virtual environment")
    else:
        print("✅ Virtual environment already exists")
        return True

def activate_virtual_environment():
    """Activate virtual environment"""
    if os.name == 'nt':  # Windows
        activate_script = "venv\\Scripts\\activate"
    else:  # Unix/Linux/MacOS
        activate_script = "venv/bin/activate"
    
    print(f"📝 To activate the virtual environment, run:")
    print(f"   {activate_script}")
    return True

def install_dependencies():
    """Install Python dependencies"""
    if os.name == 'nt':  # Windows
        pip_command = "venv\\Scripts\\pip"
    else:  # Unix/Linux/MacOS
        pip_command = "venv/bin/pip"
    
    return run_command(f"{pip_command} install -r requirements.txt", "Installing dependencies")

def create_env_file():
    """Create .env file from template"""
    if not os.path.exists(".env"):
        if os.path.exists("env.example"):
            run_command("cp env.example .env", "Creating .env file from template")
            print("📝 Please edit .env file with your configuration")
        else:
            print("⚠️  env.example not found, please create .env file manually")
    else:
        print("✅ .env file already exists")

def initialize_database():
    """Initialize database"""
    if os.name == 'nt':  # Windows
        flask_command = "venv\\Scripts\\flask"
    else:  # Unix/Linux/MacOS
        flask_command = "venv/bin/flask"
    
    # Set Flask app environment variable
    os.environ['FLASK_APP'] = 'app.py'
    
    commands = [
        f"{flask_command} db init",
        f"{flask_command} db migrate -m 'Initial migration'",
        f"{flask_command} db upgrade"
    ]
    
    for command in commands:
        if not run_command(command, f"Running: {command}"):
            print("⚠️  Database initialization failed. Please check your database configuration.")
            return False
    
    return True

def main():
    """Main setup function"""
    print("🚀 Setting up FitAI Backend...")
    print("=" * 50)
    
    # Check Python version
    check_python_version()
    
    # Create virtual environment
    if not create_virtual_environment():
        sys.exit(1)
    
    # Install dependencies
    if not install_dependencies():
        sys.exit(1)
    
    # Create .env file
    create_env_file()
    
    # Initialize database
    print("\n📊 Database Setup:")
    print("Please ensure you have a database configured in your .env file")
    print("For SQLite (default), no additional setup is required")
    print("For PostgreSQL, please create the database first")
    
    response = input("\nDo you want to initialize the database now? (y/n): ")
    if response.lower() == 'y':
        initialize_database()
    
    # Show activation instructions
    print("\n" + "=" * 50)
    print("🎉 Setup completed successfully!")
    print("\nNext steps:")
    print("1. Activate the virtual environment:")
    if os.name == 'nt':  # Windows
        print("   venv\\Scripts\\activate")
    else:  # Unix/Linux/MacOS
        print("   source venv/bin/activate")
    
    print("2. Edit .env file with your configuration")
    print("3. Run the application:")
    print("   python app.py")
    print("\nFor more information, see README.md")

if __name__ == "__main__":
    main()
