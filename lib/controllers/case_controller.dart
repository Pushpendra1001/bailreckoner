import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/case_model.dart';
import '../services/case_service.dart';

final caseServiceProvider = Provider<CaseService>((ref) => CaseService());

final allCasesProvider = FutureProvider<List<CaseModel>>((ref) async {
  final caseService = ref.watch(caseServiceProvider);
  return await caseService.getAllCases();
});

final caseByIdProvider = FutureProvider.family<CaseModel?, String>((
  ref,
  id,
) async {
  final caseService = ref.watch(caseServiceProvider);
  return await caseService.getCaseById(id);
});

class CurrentCaseNotifier extends StateNotifier<CaseModel?> {
  CurrentCaseNotifier() : super(null);

  void setCase(CaseModel caseModel) {
    state = caseModel;
  }

  void clearCase() {
    state = null;
  }
}

final currentCaseProvider =
    StateNotifierProvider<CurrentCaseNotifier, CaseModel?>((ref) {
      return CurrentCaseNotifier();
    });
