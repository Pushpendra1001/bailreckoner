import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/ai_controller.dart';
import '../../controllers/case_controller.dart';
import '../../widgets/custom_button.dart';
import '../../services/pdf_service.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';

class BailGeneratorScreen extends ConsumerWidget {
  const BailGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationAsync = ref.watch(bailApplicationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Bail Application')),
      body: applicationAsync.when(
        data: (application) {
          if (application == null) {
            return const Center(child: Text('No application available'));
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
                              Icons.description,
                              size: 60,
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Bail Application Generated',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Case: ${application.caseNumber}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSection(context, 'Court', application.courtName),
                    _buildSection(
                      context,
                      'Applicant',
                      application.applicantName,
                    ),
                    _buildSection(
                      context,
                      'Case Number',
                      application.caseNumber,
                    ),
                    _buildSection(
                      context,
                      'Date',
                      Utils.formatDate(application.generatedDate),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailSection(
                      context,
                      'Case Summary',
                      application.summary,
                    ),
                    _buildDetailSection(
                      context,
                      'Legal Reasoning',
                      application.legalReasoning,
                    ),
                    _buildDetailSection(
                      context,
                      'Arguments for Bail',
                      application.arguments,
                    ),
                    _buildDetailSection(
                      context,
                      'Mitigation Factors',
                      application.mitigationFactors,
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      text: 'View & Share PDF',
                      onPressed: () async {
                        if (!context.mounted) return;
                        try {
                          Utils.showLoadingDialog(context);
                          final pdfService = PDFService();

                          try {
                            // Try file-based approach first
                            final file = await pdfService
                                .generateBailApplicationPDF(application);
                            if (context.mounted) {
                              Navigator.pop(context);
                              await pdfService.sharePDF(file);
                              if (context.mounted) {
                                Utils.showSnackBar(
                                  context,
                                  'PDF generated successfully!',
                                );
                              }
                            }
                          } catch (e) {
                            // Fallback: Direct share without file
                            if (context.mounted) {
                              Navigator.pop(context);
                              Utils.showLoadingDialog(context);
                            }
                            await pdfService.generateAndSharePDF(application);
                            if (context.mounted) {
                              Navigator.pop(context);
                              Utils.showSnackBar(context, 'PDF ready!');
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            Navigator.pop(context);
                            Utils.showSnackBar(
                              context,
                              'Error: ${e.toString()}',
                              isError: true,
                            );
                          }
                        }
                      },
                      icon: Icons.picture_as_pdf,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () async {
                        if (!context.mounted) return;
                        try {
                          Utils.showLoadingDialog(context);
                          final pdfService = PDFService();

                          try {
                            final file = await pdfService
                                .generateBailApplicationPDF(application);
                            if (context.mounted) {
                              Navigator.pop(context);
                              await pdfService.sharePDF(file);
                              if (context.mounted) {
                                Utils.showSnackBar(
                                  context,
                                  'PDF ready to share!',
                                );
                              }
                            }
                          } catch (e) {
                            // Direct share fallback
                            if (context.mounted) Navigator.pop(context);
                            await pdfService.generateAndSharePDF(application);
                            if (context.mounted) {
                              Utils.showSnackBar(context, 'Shared!');
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            Utils.showSnackBar(
                              context,
                              'Error: ${e.toString()}',
                              isError: true,
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Share PDF'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Clear the case to prevent duplicate reports
                        ref.read(currentCaseProvider.notifier).clearCase();
                        ref.invalidate(bailApplicationProvider);
                        ref.invalidate(eligibilityPredictionProvider);
                        ref.invalidate(nlpAnalysisProvider);

                        // Go back to dashboard
                        context.go(AppConstants.routePrisonerDashboard);
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Done - Back to Dashboard'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
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

  Widget _buildSection(BuildContext context, String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                '$label:',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(
    BuildContext context,
    String title,
    String content,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
