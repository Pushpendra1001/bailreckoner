import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ai_service.dart';
import '../models/nlp_analysis_result.dart';
import '../models/eligibility_prediction.dart';
import '../models/bail_application.dart';
import '../models/risk_analysis.dart';

final aiServiceProvider = Provider<AIService>((ref) => AIService());

class NLPAnalysisNotifier
    extends StateNotifier<AsyncValue<NLPAnalysisResult?>> {
  final AIService aiService;

  NLPAnalysisNotifier(this.aiService) : super(const AsyncValue.data(null));

  Future<void> analyzeCase(String caseText) async {
    state = const AsyncValue.loading();
    try {
      final result = await aiService.analyzeCaseNLP(caseText);
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void clear() {
    state = const AsyncValue.data(null);
  }
}

final nlpAnalysisProvider =
    StateNotifierProvider<NLPAnalysisNotifier, AsyncValue<NLPAnalysisResult?>>((
      ref,
    ) {
      final aiService = ref.watch(aiServiceProvider);
      return NLPAnalysisNotifier(aiService);
    });

class EligibilityPredictionNotifier
    extends StateNotifier<AsyncValue<EligibilityPrediction?>> {
  final AIService aiService;

  EligibilityPredictionNotifier(this.aiService)
    : super(const AsyncValue.data(null));

  Future<void> predictEligibility(caseData) async {
    state = const AsyncValue.loading();
    try {
      final result = await aiService.predictEligibility(caseData);
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void clear() {
    state = const AsyncValue.data(null);
  }
}

final eligibilityPredictionProvider =
    StateNotifierProvider<
      EligibilityPredictionNotifier,
      AsyncValue<EligibilityPrediction?>
    >((ref) {
      final aiService = ref.watch(aiServiceProvider);
      return EligibilityPredictionNotifier(aiService);
    });

class BailApplicationNotifier
    extends StateNotifier<AsyncValue<BailApplication?>> {
  final AIService aiService;

  BailApplicationNotifier(this.aiService) : super(const AsyncValue.data(null));

  Future<void> generateApplication(caseData) async {
    state = const AsyncValue.loading();
    try {
      final result = await aiService.generateBailApplication(caseData);
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void clear() {
    state = const AsyncValue.data(null);
  }
}

final bailApplicationProvider =
    StateNotifierProvider<
      BailApplicationNotifier,
      AsyncValue<BailApplication?>
    >((ref) {
      final aiService = ref.watch(aiServiceProvider);
      return BailApplicationNotifier(aiService);
    });

class RiskAnalysisNotifier extends StateNotifier<AsyncValue<RiskAnalysis?>> {
  final AIService aiService;

  RiskAnalysisNotifier(this.aiService) : super(const AsyncValue.data(null));

  Future<void> analyzeRisk(caseData) async {
    state = const AsyncValue.loading();
    try {
      final result = await aiService.judgeRiskAnalysis(caseData);
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void clear() {
    state = const AsyncValue.data(null);
  }
}

final riskAnalysisProvider =
    StateNotifierProvider<RiskAnalysisNotifier, AsyncValue<RiskAnalysis?>>((
      ref,
    ) {
      final aiService = ref.watch(aiServiceProvider);
      return RiskAnalysisNotifier(aiService);
    });
