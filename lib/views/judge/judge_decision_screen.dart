import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/ai_controller.dart';
import '../../controllers/case_controller.dart';
import '../../widgets/custom_button.dart';
import '../../services/case_service.dart';
import '../../services/notification_service.dart';
import '../../core/utils.dart';
import '../../models/case_model.dart';

class JudgeDecisionScreen extends ConsumerStatefulWidget {
  const JudgeDecisionScreen({super.key});

  @override
  ConsumerState<JudgeDecisionScreen> createState() =>
      _JudgeDecisionScreenState();
}

class _JudgeDecisionScreenState extends ConsumerState<JudgeDecisionScreen> {
  bool _isAnalyzing = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _analyzeCase();
    });
  }

  Future<void> _analyzeCase() async {
    final currentCase = ref.read(currentCaseProvider);
    if (currentCase != null) {
      await ref.read(riskAnalysisProvider.notifier).analyzeRisk(currentCase);
      setState(() => _isAnalyzing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCase = ref.watch(currentCaseProvider);
    final riskAnalysisAsync = ref.watch(riskAnalysisProvider);

    if (currentCase == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Case Decision')),
        body: const Center(child: Text('No case selected')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Case Decision')),
      body: _isAnalyzing
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Analyzing case...'),
                ],
              ),
            )
          : riskAnalysisAsync.when(
              data: (analysis) {
                if (analysis == null) {
                  return const Center(child: Text('No analysis available'));
                }

                final riskColor = Utils.getRiskColor(analysis.riskScore);

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final padding = constraints.maxWidth > 600 ? 32.0 : 24.0;
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Case Information',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildInfoRow(
                                    'Case Number',
                                    currentCase.caseNumber,
                                  ),
                                  _buildInfoRow(
                                    'Prisoner Name',
                                    currentCase.prisonerName,
                                  ),
                                  _buildInfoRow(
                                    'Crime Category',
                                    currentCase.crimeCategory,
                                  ),
                                  _buildInfoRow(
                                    'Previous Convictions',
                                    currentCase.previousConvictions.toString(),
                                  ),
                                  _buildInfoRow(
                                    'Days in Custody',
                                    currentCase.daysInCustody.toString(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Card(
                            color: riskColor.withValues(alpha: 0.1),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Risk Assessment',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 16),
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        height: 150,
                                        child: CircularProgressIndicator(
                                          value: analysis.riskScore / 100,
                                          strokeWidth: 12,
                                          backgroundColor: Colors.grey
                                              .withValues(alpha: 0.2),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                riskColor,
                                              ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            '${analysis.riskScore.toStringAsFixed(0)}%',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: riskColor,
                                                ),
                                          ),
                                          Text(
                                            'Risk Score',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: riskColor,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Text(
                                      '${analysis.riskLevel.toUpperCase()} RISK',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (analysis.highRiskFactors.isNotEmpty)
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.warning, color: Colors.red),
                                        const SizedBox(width: 12),
                                        Text(
                                          'High Risk Factors',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    ...analysis.highRiskFactors.map(
                                      (factor) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.circle,
                                              size: 8,
                                              color: Colors.red,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(child: Text(factor)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),
                          if (analysis.missingDocuments.isNotEmpty)
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.description,
                                          color: Colors.orange,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Missing Documents',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    ...analysis.missingDocuments.map(
                                      (doc) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.circle,
                                              size: 8,
                                              color: Colors.orange,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(child: Text(doc)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),
                          Card(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'System Recommendation',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(analysis.recommendation),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Suggested Action:',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(analysis.suggestedAction),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Your Decision',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  text: 'Approve Bail',
                                  onPressed: () =>
                                      _submitDecision(currentCase, 'approved'),
                                  backgroundColor: Colors.green,
                                  icon: Icons.check,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomButton(
                                  text: 'Reject Bail',
                                  onPressed: () =>
                                      _submitDecision(currentCase, 'rejected'),
                                  backgroundColor: Colors.red,
                                  icon: Icons.close,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _submitDecision(CaseModel caseData, String decision) async {
    Utils.showLoadingDialog(context);

    final updatedCase = CaseModel(
      id: caseData.id,
      caseNumber: caseData.caseNumber,
      prisonerName: caseData.prisonerName,
      description: caseData.description,
      charges: caseData.charges,
      ipcSections: caseData.ipcSections,
      crimeCategory: caseData.crimeCategory,
      previousConvictions: caseData.previousConvictions,
      daysInCustody: caseData.daysInCustody,
      criminalHistory: caseData.criminalHistory,
      filedDate: caseData.filedDate,
      status: decision,
      lawyerId: caseData.lawyerId,
      judgeId: caseData.judgeId,
    );

    final caseService = CaseService();
    await caseService.updateCase(updatedCase);

    final notificationService = NotificationService();
    await notificationService.createCaseNotification(
      caseData.caseNumber,
      decision,
    );

    ref.invalidate(allCasesProvider);
    ref.read(currentCaseProvider.notifier).clearCase();

    if (mounted) {
      Navigator.pop(context);
      Utils.showSnackBar(
        context,
        'Decision submitted: ${decision == 'approved' ? 'Bail Approved' : 'Bail Rejected'}',
      );
      context.pop();
    }
  }
}
