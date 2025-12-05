class AppConstants {
  static const String appName = 'Bail Reckoner';
  static const String geminiApiKey = 'AIzaSyB-KRcFo8Rd4MmERv4ABN_avALEIbWocJs';

  // User Roles
  static const String rolePrisoner = 'prisoner';
  static const String roleLawyer = 'lawyer';
  static const String roleJudge = 'judge';

  // Routes
  static const String routeSplash = '/';
  static const String routeRoleSelection = '/role-selection';
  static const String routePrisonerLogin = '/prisoner-login';
  static const String routeLawyerLogin = '/lawyer-login';
  static const String routeJudgeLogin = '/judge-login';
  static const String routePrisonerDashboard = '/prisoner-dashboard';
  static const String routeLawyerDashboard = '/lawyer-dashboard';
  static const String routeJudgeDashboard = '/judge-dashboard';
  static const String routeCaseInput = '/case-input';
  static const String routeNLPAnalysis = '/nlp-analysis';
  static const String routeEligibilityPrediction = '/eligibility-prediction';
  static const String routeBailGenerator = '/bail-generator';
  static const String routeJudgeDecision = '/judge-decision';
  static const String routeNotifications = '/notifications';

  // IPC Sections
  static const List<String> ipcSections = [
    'Section 302 - Murder',
    'Section 307 - Attempt to Murder',
    'Section 376 - Rape',
    'Section 420 - Cheating',
    'Section 379 - Theft',
    'Section 323 - Voluntarily causing hurt',
    'Section 504 - Intentional insult',
    'Section 506 - Criminal intimidation',
  ];

  // Crime Categories
  static const List<String> crimeCategories = [
    'Violent Crime',
    'Property Crime',
    'Economic Crime',
    'Cyber Crime',
    'Drug-related Crime',
    'Sexual Offense',
    'White Collar Crime',
    'Minor Offense',
  ];
}
