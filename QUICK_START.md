# 🚀 Quick Start Guide - FitAI

Get FitAI up and running in 5 minutes!

## ⚡ One-Command Setup

```bash
# Clone and setup everything automatically
git clone https://github.com/yourusername/fitness_app.git
cd fitness_app
chmod +x setup.sh
./setup.sh
```

## 🔑 Required API Keys

### 1. Google Gemini AI (Required)
1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with Google
3. Click "Create API Key"
4. Copy the key
5. Add to `backend/.env`:
   ```env
   GEMINI_API_KEY=your-api-key-here
   ```

### 2. Firebase (Optional)
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Enable Authentication and Firestore
4. Download service account key
5. Add to `backend/.env`:
   ```env
   FIREBASE_PROJECT_ID=your-project-id
   FIREBASE_PRIVATE_KEY=your-private-key
   FIREBASE_CLIENT_EMAIL=your-client-email
   ```

## 🏃‍♂️ Run the App

### Option 1: Using Run Scripts
```bash
# Terminal 1 - Backend
./run_backend.sh

# Terminal 2 - Frontend
./run_frontend.sh
```

### Option 2: Manual Commands
```bash
# Terminal 1 - Backend
cd backend
source venv/bin/activate
python app.py

# Terminal 2 - Frontend
cd frontend
flutter run
```

## 🌐 Access the App

- **Frontend**: http://localhost:3000 (or device IP)
- **Backend API**: http://localhost:5000
- **API Docs**: http://localhost:5000/docs

## 📱 Supported Platforms

- ✅ **Web** (Chrome, Firefox, Safari)
- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 11+)
- ✅ **macOS** (10.14+)
- ✅ **Windows** (10+)
- ✅ **Linux** (Ubuntu 18.04+)

## 🔧 Troubleshooting

### Common Issues

**1. Flutter not found**
```bash
# Install Flutter
# Visit: https://flutter.dev/docs/get-started/install
```

**2. Python/pip not found**
```bash
# Install Python 3
# macOS: brew install python3
# Ubuntu: sudo apt install python3 python3-pip
```

**3. Port already in use**
```bash
# Kill processes using ports 3000 and 5000
lsof -ti:3000 | xargs kill -9
lsof -ti:5000 | xargs kill -9
```

**4. API key not working**
- Check if the key is correctly added to `.env`
- Verify the key is active in Google AI Studio
- Restart the backend server

### Get Help

- 📖 **Full Documentation**: [README.md](README.md)
- 🐛 **Report Issues**: [GitHub Issues](https://github.com/yourusername/fitness_app/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/yourusername/fitness_app/discussions)

## 🎯 What's Next?

1. **Configure your profile** in the app
2. **Set your fitness goals** and preferences
3. **Generate your first AI workout plan**
4. **Start tracking your progress**
5. **Explore all the features**

---

**Happy coding! 🏋️‍♀️💪**
