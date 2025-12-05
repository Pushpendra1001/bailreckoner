import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../controllers/ai_controller.dart';
import '../../controllers/case_controller.dart';
import '../../widgets/custom_button.dart';
import '../../core/utils.dart';

class EligibilityPredictionScreen extends ConsumerWidget {
  const EligibilityPredictionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final predictionAsync = ref.watch(eligibilityPredictionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Bail Eligibility')),
      body: predictionAsync.when(
        data: (prediction) {
          if (prediction == null) {
            return const Center(child: Text('No prediction available'));
          }

          final color = Utils.getRiskColor(100 - prediction.probabilityScore);

          return LayoutBuilder(
            builder: (context, constraints) {
              final padding = constraints.maxWidth > 600 ? 32.0 : 24.0;
              return SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      color: color.withValues(alpha: 0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: CircularProgressIndicator(
                                    value: prediction.probabilityScore / 100,
                                    strokeWidth: 12,
                                    backgroundColor: Colors.grey.withValues(
                                      alpha: 0.2,
                                    ),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      color,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '${prediction.probabilityScore.toStringAsFixed(0)}%',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: color,
                                          ),
                                    ),
                                    Text(
                                      'Eligibility',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text(
                                prediction.recommendation.toUpperCase(),
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
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Explanation',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              prediction.explanation,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green),
                                const SizedBox(width: 12),
                                Text(
                                  'Favorable Factors',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...prediction.favorableFactors.map(
                              (factor) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: Colors.green,
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
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.cancel, color: Colors.red),
                                const SizedBox(width: 12),
                                Text(
                                  'Unfavorable Factors',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...prediction.unfavorableFactors.map(
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
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.description, color: Colors.blue),
                                const SizedBox(width: 12),
                                Text(
                                  'Required Documents',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...prediction.requiredDocuments.map(
                              (doc) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: Colors.blue,
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
                    const SizedBox(height: 32),
                    CustomButton(
                      text: 'Generate Bail Application',
                      onPressed: () async {
                        final currentCase = ref.read(currentCaseProvider);
                        if (currentCase != null) {
                          Utils.showLoadingDialog(context);
                          await ref
                              .read(bailApplicationProvider.notifier)
                              .generateApplication(currentCase);
                          if (context.mounted) {
                            Navigator.pop(context);
                            context.push(AppConstants.routeBailGenerator);
                          }
                        }
                      },
                      icon: Icons.description,
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
