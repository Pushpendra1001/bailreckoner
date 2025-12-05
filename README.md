# 🏛️ Bail Reckoner - AI-Powered Legal Assistant

[![Flutter](https://img.shields.io/badge/Flutter-3.35.7-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.6-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

> An intelligent Flutter application that revolutionizes the Indian bail system using AI-powered analysis, prediction, and document generation.

---

## 📱 Download APK

### Option 1: Download from GitHub Releases (Recommended)
1. Go to [Releases](https://github.com/Pushpendra1001/bailreckoner/releases)
2. Download the latest `app-release.apk` file (50MB)

### Option 2: Clone and Build
```bash
git clone https://github.com/Pushpendra1001/bailreckoner.git
cd bailreckoner
```
The pre-built APK is available at: `build/app/outputs/flutter-apk/app-release.apk`

### Installation Instructions:
1. Download the APK file using one of the methods above
2. On your Android device, enable "Install from Unknown Sources" in Settings → Security
3. Transfer the APK to your device (if downloaded on PC)
4. Open the APK file and tap "Install"
5. Grant necessary permissions when prompted (Storage, etc.)
6. Launch the app and select your role (Prisoner/Lawyer/Judge)

**Note:** If you don't see a release, you can build the APK yourself using the instructions in the Setup section below.

---

## ✨ Key Features

### 🤖 **AI-Powered Intelligence**
- **Smart Crime Detection** - Automatically identifies crime types and applicable IPC sections from case descriptions
- **Bail Eligibility Prediction** - ML-based scoring considering crime severity, history, and custody time
- **Automated Document Generation** - Creates professional bail applications using Gemini AI
- **Legal Chatbot Assistant** - 24/7 AI guidance for judges and lawyers on bail procedures

### 👥 **Multi-Role System**
- **Undertrial Prisoners** - Apply for bail, track case status, generate applications
- **Legal Aid Lawyers** - Manage client cases, analyze complexity, strengthen applications
- **Judicial Authorities** - Review cases, evaluate risk, make informed decisions

### 🎯 **Smart Features**
- **Auto-Detect IPC Sections** - One-click AI analysis to suggest relevant legal sections
- **NLP Case Analysis** - Extract charges, identify risk factors, categorize crimes
- **Risk Assessment** - Comprehensive scoring for judicial decision-making
- **PDF Generation & Sharing** - Professional documents ready for court submission
- **Real-time Notifications** - Stay updated on case status changes

---

## 🚀 How It Works

### For Prisoners:
1. **Enter Case Details** → Describe your situation
2. **Auto-Detect Sections** → AI suggests applicable IPC sections
3. **Analyze Case** → Get NLP-powered insights
4. **Check Eligibility** → See bail probability score
5. **Generate Application** → AI creates professional document
6. **Download & Submit** → Share PDF with lawyer/court

### For Lawyers:
1. **Add Client Cases** → Input client information
2. **AI Assistant** → Get legal strategies and guidance
3. **Analyze Complexity** → Understand case strengths/weaknesses
4. **Strengthen Application** → AI-powered arguments
5. **Track Progress** → Monitor all client cases

### For Judges:
1. **Review Applications** → Access pending cases
2. **AI Risk Analysis** → Get comprehensive risk assessment
3. **Legal Guidance** → Chatbot for bail law queries
4. **Make Decision** → Approve/reject with confidence
5. **Case Management** → Efficient workflow

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|-----------|
| **Framework** | Flutter 3.35.7 |
| **Language** | Dart 3.6 |
| **AI/ML** | Google Gemini 1.5 Flash |
| **State Management** | Riverpod 2.6.1 |
| **Navigation** | GoRouter 14.8.1 |
| **PDF Generation** | pdf 3.11.1 + printing 5.13.2 |
| **Local Storage** | SharedPreferences 2.3.2 |
| **UI Framework** | Material Design 3 |

---

## 📦 Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.6.1
  go_router: ^14.8.1
  google_generative_ai: ^0.4.6
  shared_preferences: ^2.3.2
  pdf: ^3.11.1
  printing: ^5.13.2
  path_provider: ^2.1.4
  dio: ^5.4.3+1
  uuid: ^4.5.1
  intl: ^0.19.0
```

---

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── constants.dart          # App-wide constants & API keys
│   ├── theme.dart              # Material 3 theme configuration
│   ├── router.dart             # GoRouter navigation setup
│   └── utils.dart              # Helper functions
├── models/
│   ├── user_model.dart
│   ├── case_model.dart
│   ├── nlp_analysis_result.dart
│   ├── eligibility_prediction.dart
│   ├── bail_application.dart
│   ├── risk_analysis.dart
│   └── notification_model.dart
├── services/
│   ├── ai_service.dart         # Gemini AI integration
│   ├── chatbot_service.dart    # Legal assistant chatbot
│   ├── auth_service.dart       # Mock authentication
│   ├── case_service.dart       # Case management
│   ├── pdf_service.dart        # PDF generation
│   └── notification_service.dart
├── controllers/
│   ├── auth_controller.dart    # Auth state management
│   ├── case_controller.dart    # Case state management
│   ├── ai_controller.dart      # AI operations
│   └── notification_controller.dart
├── views/
│   ├── common/                 # Shared screens
│   ├── prisoner/              # Prisoner-specific screens
│   ├── lawyer/                # Lawyer-specific screens
│   └── judge/                 # Judge-specific screens
└── widgets/                    # Reusable UI components
```

---

## 🔑 Setup & Configuration

### Prerequisites:
- Flutter SDK 3.35.7 or higher
- Dart 3.6 or higher
- Android Studio / VS Code
- Google Gemini API Key

### Installation:

1. **Clone the repository**
```bash
git clone https://github.com/Pushpendra1001/bailreckoner.git
cd bailreckoner
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure Gemini API Key**

Open `lib/core/constants.dart` and add your API key:
```dart
static const String geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
```

Get your free API key from: [Google AI Studio](https://makersuite.google.com/app/apikey)

4. **Run the app**
```bash
flutter run
```

5. **Build APK**
```bash
flutter build apk --release
```

---

## 📸 Screenshots

### Prisoner Flow
- Case Input with Auto-Detect IPC Sections
- NLP Analysis Results
- Bail Eligibility Prediction
- AI-Generated Application

### Lawyer Dashboard
- Client Case Management
- AI Legal Assistant Chatbot
- Document Repository
- Case Statistics

### Judge Dashboard
- Pending Cases Review
- Risk Analysis Report
- AI Decision Support
- Case Decision Interface

---

## 🎓 AI Capabilities

### 1. **Smart Crime Detection**
- Analyzes case descriptions using NLP
- Maps crimes to correct IPC sections automatically
- Identifies: Theft, Murder, Assault, Fraud, Rape, Kidnapping, etc.

### 2. **Intelligent Bail Scoring**
```
Score Factors:
✓ Crime Category (Property: +20, Violent: -25, Sexual: -30)
✓ Previous Convictions (First-time: +15, Each conviction: -10)
✓ Days in Custody (>90 days: +20, >30 days: +10)
✓ IPC Section Severity (Bailable: +15, Non-bailable: -30)
```

### 3. **Legal Chatbot**
- Restricted to judicial/legal topics only
- Context-aware responses for judges & lawyers
- Cites relevant IPC/CrPC sections
- Provides case law references
- Available 24/7

---

## 🔒 Security & Privacy

- ✅ Local data storage using SharedPreferences
- ✅ No user data sent to external servers (except Gemini AI for analysis)
- ✅ Mock authentication for demo purposes
- ✅ PDF files stored in secure app directory
- ✅ Android permissions properly configured

---

## 🌟 Highlights

- 🚀 **Fast & Efficient** - Processes cases in seconds
- 🎯 **Accurate Predictions** - AI-powered legal analysis
- 📱 **Mobile-First** - Optimized for Android devices
- 🌐 **Offline Ready** - Core features work without internet
- 🔄 **Real-time Updates** - Instant notifications
- 📄 **Professional PDFs** - Court-ready documents
- 🤖 **24/7 AI Assistant** - Always available legal guidance

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Developer

**Pushpendra Singh**
- GitHub: [@Pushpendra1001](https://github.com/Pushpendra1001)

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📞 Support

For support, email: [your-email@example.com](mailto:your-email@example.com)

---

## 🙏 Acknowledgments

- Google Gemini AI for powerful language models
- Flutter team for excellent framework
- Indian Penal Code reference materials
- Open-source community

---

## 🔮 Future Enhancements

- [ ] Multi-language support (Hindi, Tamil, Telugu)
- [ ] Voice input for case description
- [ ] Integration with real court databases
- [ ] Biometric authentication
- [ ] Case precedent search engine
- [ ] Video consultation feature
- [ ] Real-time court updates
- [ ] Document OCR scanning

---

## ⚖️ Disclaimer

This app is for educational and demonstration purposes. It does not constitute legal advice. Always consult with qualified legal professionals for actual legal matters.

---

<div align="center">

### Made with ❤️ using Flutter

**Star ⭐ this repo if you find it helpful!**

[Report Bug](https://github.com/Pushpendra1001/bailreckoner/issues) · [Request Feature](https://github.com/Pushpendra1001/bailreckoner/issues)

</div>
