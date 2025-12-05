import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../controllers/ai_controller.dart';
import '../../controllers/case_controller.dart';
import '../../widgets/info_card.dart';
import '../../widgets/custom_button.dart';

class NLPAnalysisScreen extends ConsumerWidget {
  const NLPAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisAsync = ref.watch(nlpAnalysisProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Case Analysis')),
      body: analysisAsync.when(
        data: (analysis) {
          if (analysis == null) {
            return const Center(child: Text('No analysis available'));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final padding = constraints.maxWidth > 600 ? 32.0 : 24.0;
              return SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 60,
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Analysis Complete',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Confidence: ${(analysis.confidence * 100).toStringAsFixed(0)}%',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Extracted Information',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    InfoCard(
                      title: 'Crime Category',
                      value: analysis.crimeCategory,
                      icon: Icons.category,
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.gavel,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Charges',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...analysis.extractedCharges.map(
                              (charge) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.circle, size: 8),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(charge)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.book,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'IPC Sections',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...analysis.extractedSections.map(
                              (section) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.circle, size: 8),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(section)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.warning, color: Colors.orange),
                                const SizedBox(width: 12),
                                Text(
                                  'Risk Factors',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...analysis.riskFactors.map(
                              (factor) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.circle, size: 8),
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
                    const SizedBox(height: 32),
                    CustomButton(
                      text: 'Check Eligibility',
                      onPressed: () async {
                        final currentCase = ref.read(currentCaseProvider);
                        if (currentCase != null) {
                          await ref
                              .read(eligibilityPredictionProvider.notifier)
                              .predictEligibility(currentCase);
                          if (context.mounted) {
                            context.push(
                              AppConstants.routeEligibilityPrediction,
                            );
                          }
                        }
                      },
                      icon: Icons.arrow_forward,
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
}
