#!/bin/bash

# FitAI - AI Fitness & Nutrition Tracker Setup Script
# This script sets up both the Flutter frontend and Flask backend

set -e

echo "🏋️‍♀️ Welcome to FitAI - AI Fitness & Nutrition Tracker Setup!"
echo "=============================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required tools are installed
check_requirements() {
    print_status "Checking system requirements..."
    
    # Check Flutter
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed. Please install Flutter first."
        print_status "Visit: https://flutter.dev/docs/get-started/install"
        exit 1
    fi
    
    # Check Python
    if ! command -v python3 &> /dev/null; then
        print_error "Python 3 is not installed. Please install Python 3 first."
        exit 1
    fi
    
    # Check pip
    if ! command -v pip3 &> /dev/null; then
        print_error "pip3 is not installed. Please install pip3 first."
        exit 1
    fi
    
    print_success "All requirements are satisfied!"
}

# Setup backend
setup_backend() {
    print_status "Setting up Flask backend..."
    
    cd backend
    
    # Create virtual environment
    print_status "Creating Python virtual environment..."
    python3 -m venv venv
    
    # Activate virtual environment
    print_status "Activating virtual environment..."
    source venv/bin/activate
    
    # Install dependencies
    print_status "Installing Python dependencies..."
    pip install -r requirements.txt
    
    # Create .env file if it doesn't exist
    if [ ! -f .env ]; then
        print_status "Creating environment configuration file..."
        cp env.example .env
        print_warning "Please edit backend/.env file with your API keys and configuration!"
    fi
    
    # Initialize database
    print_status "Initializing database..."
    python -c "from app import create_app, db; app = create_app(); app.app_context().push(); db.create_all()" || true
    
    print_success "Backend setup completed!"
    cd ..
}

# Setup frontend
setup_frontend() {
    print_status "Setting up Flutter frontend..."
    
    cd frontend
    
    # Get Flutter dependencies
    print_status "Installing Flutter dependencies..."
    flutter pub get
    
    # Check Flutter doctor
    print_status "Running Flutter doctor..."
    flutter doctor
    
    print_success "Frontend setup completed!"
    cd ..
}

# Create run scripts
create_run_scripts() {
    print_status "Creating run scripts..."
    
    # Backend run script
    cat > run_backend.sh << 'EOF'
#!/bin/bash
cd backend
source venv/bin/activate
python app.py
EOF
    chmod +x run_backend.sh
    
    # Frontend run script
    cat > run_frontend.sh << 'EOF'
#!/bin/bash
cd frontend
flutter run
EOF
    chmod +x run_frontend.sh
    
    print_success "Run scripts created!"
}

# Main setup function
main() {
    echo
    print_status "Starting FitAI setup process..."
    echo
    
    # Check requirements
    check_requirements
    
    # Setup backend
    setup_backend
    
    # Setup frontend
    setup_frontend
    
    # Create run scripts
    create_run_scripts
    
    echo
    echo "=============================================================="
    print_success "🎉 FitAI setup completed successfully!"
    echo "=============================================================="
    echo
    print_status "Next steps:"
    echo "1. Edit backend/.env file with your API keys:"
    echo "   - Get Gemini API key from: https://makersuite.google.com/app/apikey"
    echo "   - Add your Firebase configuration (optional)"
    echo
    print_status "2. Run the application:"
    echo "   - Backend: ./run_backend.sh"
    echo "   - Frontend: ./run_frontend.sh"
    echo
    print_status "3. Or run manually:"
    echo "   - Backend: cd backend && source venv/bin/activate && python app.py"
    echo "   - Frontend: cd frontend && flutter run"
    echo
    print_warning "Make sure to configure your API keys before running the app!"
    echo
}

# Run main function
main "$@"
