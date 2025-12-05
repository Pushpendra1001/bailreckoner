import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../controllers/case_controller.dart';
import '../../widgets/case_card.dart';
import '../../core/utils.dart';

class CaseListScreen extends ConsumerWidget {
  const CaseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final casesAsync = ref.watch(allCasesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cases'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(allCasesProvider);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: casesAsync.when(
          data: (cases) {
            if (cases.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.folder_open, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No cases found'),
                    SizedBox(height: 8),
                    Text(
                      'Create a new case to get started',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final padding = constraints.maxWidth > 600 ? 24.0 : 16.0;
                return ListView.builder(
                  padding: EdgeInsets.all(padding),
                  itemCount: cases.length,
                  itemBuilder: (context, index) {
                    final caseData = cases[index];
                    return CaseCard(
                      caseNumber: caseData.caseNumber,
                      prisonerName: caseData.prisonerName,
                      status: caseData.status,
                      date: Utils.formatDate(caseData.filedDate),
                      onTap: () {
                        ref
                            .read(currentCaseProvider.notifier)
                            .setCase(caseData);
                        context.push(AppConstants.routeEligibilityPrediction);
                      },
                    );
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${error.toString()}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(allCasesProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.read(currentCaseProvider.notifier).clearCase();
          context.push(AppConstants.routeCaseInput);
        },
        icon: const Icon(Icons.add),
        label: const Text('New Case'),
      ),
    );
  }
}
