import 'package:go_router/go_router.dart';
import '../core/constants.dart';
import '../views/common/splash_screen.dart';
import '../views/common/role_selection_screen.dart';
import '../views/common/notifications_screen.dart';
import '../views/common/case_list_screen.dart';
import '../views/common/search_case_screen.dart';
import '../views/common/documents_screen.dart';
import '../views/prisoner/prisoner_login_screen.dart';
import '../views/prisoner/prisoner_dashboard_screen.dart';
import '../views/prisoner/case_input_screen.dart';
import '../views/prisoner/nlp_analysis_screen.dart';
import '../views/prisoner/eligibility_prediction_screen.dart';
import '../views/prisoner/bail_generator_screen.dart';
import '../views/lawyer/lawyer_login_screen.dart';
import '../views/lawyer/lawyer_dashboard_screen.dart';
import '../views/judge/judge_login_screen.dart';
import '../views/judge/judge_dashboard_screen.dart';
import '../views/judge/judge_decision_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: AppConstants.routeSplash,
  routes: [
    GoRoute(
      path: AppConstants.routeSplash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppConstants.routeRoleSelection,
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: AppConstants.routePrisonerLogin,
      builder: (context, state) => const PrisonerLoginScreen(),
    ),
    GoRoute(
      path: AppConstants.routeLawyerLogin,
      builder: (context, state) => const LawyerLoginScreen(),
    ),
    GoRoute(
      path: AppConstants.routeJudgeLogin,
      builder: (context, state) => const JudgeLoginScreen(),
    ),
    GoRoute(
      path: AppConstants.routePrisonerDashboard,
      builder: (context, state) => const PrisonerDashboardScreen(),
    ),
    GoRoute(
      path: AppConstants.routeLawyerDashboard,
      builder: (context, state) => const LawyerDashboardScreen(),
    ),
    GoRoute(
      path: AppConstants.routeJudgeDashboard,
      builder: (context, state) => const JudgeDashboardScreen(),
    ),
    GoRoute(
      path: AppConstants.routeCaseInput,
      builder: (context, state) => const CaseInputScreen(),
    ),
    GoRoute(
      path: AppConstants.routeNLPAnalysis,
      builder: (context, state) => const NLPAnalysisScreen(),
    ),
    GoRoute(
      path: AppConstants.routeEligibilityPrediction,
      builder: (context, state) => const EligibilityPredictionScreen(),
    ),
    GoRoute(
      path: AppConstants.routeBailGenerator,
      builder: (context, state) => const BailGeneratorScreen(),
    ),
    GoRoute(
      path: AppConstants.routeJudgeDecision,
      builder: (context, state) => const JudgeDecisionScreen(),
    ),
    GoRoute(
      path: AppConstants.routeNotifications,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/case-list',
      builder: (context, state) => const CaseListScreen(),
    ),
    GoRoute(
      path: '/search-case',
      builder: (context, state) => const SearchCaseScreen(),
    ),
    GoRoute(
      path: '/documents',
      builder: (context, state) => const DocumentsScreen(),
    ),
  ],
);
