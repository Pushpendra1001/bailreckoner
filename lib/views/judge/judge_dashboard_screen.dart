import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../widgets/case_card.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/case_controller.dart';
import '../../core/utils.dart';

class JudgeDashboardScreen extends ConsumerStatefulWidget {
  const JudgeDashboardScreen({super.key});

  @override
  ConsumerState<JudgeDashboardScreen> createState() =>
      _JudgeDashboardScreenState();
}

class _JudgeDashboardScreenState extends ConsumerState<JudgeDashboardScreen> {
  final _searchController = TextEditingController();
  DateTime? _lastBackPress;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final casesAsync = ref.watch(allCasesProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        final now = DateTime.now();
        if (_lastBackPress == null ||
            now.difference(_lastBackPress!) > const Duration(seconds: 2)) {
          _lastBackPress = now;
          Utils.showSnackBar(context, 'Press back again to exit');
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Judge Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.smart_toy),
              onPressed: () => context.push('/chatbot-judge'),
              tooltip: 'AI Legal Assistant',
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () => context.push(AppConstants.routeNotifications),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final authService = ref.read(authServiceProvider);
                await authService.logout();
                if (context.mounted) {
                  context.go(AppConstants.routeRoleSelection);
                }
              },
            ),
          ],
        ),
        body: userAsync.when(
          data: (user) => SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            child: Icon(
                              Icons.account_balance,
                              size: 35,
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.name ?? 'User',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user?.email ?? '',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Judicial Authority',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  casesAsync.when(
                    data: (cases) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              context,
                              'Total Cases',
                              cases.length.toString(),
                              Icons.folder,
                            ),
                            _buildStatItem(
                              context,
                              'Pending',
                              cases
                                  .where((c) => c.status == 'pending')
                                  .length
                                  .toString(),
                              Icons.pending,
                            ),
                            _buildStatItem(
                              context,
                              'Decided',
                              (cases
                                          .where((c) => c.status == 'approved')
                                          .length +
                                      cases
                                          .where((c) => c.status == 'rejected')
                                          .length)
                                  .toString(),
                              Icons.gavel,
                            ),
                          ],
                        ),
                      ),
                    ),
                    loading: () => const SizedBox(),
                    error: (_, __) => const SizedBox(),
                  ),
                  const SizedBox(height: 24),
                  // AI Assistant Card
                  Card(
                    elevation: 4,
                    color: Colors.blue.withValues(alpha: 0.1),
                    child: InkWell(
                      onTap: () => context.push('/chatbot-judge'),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.smart_toy,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'AI Legal Assistant',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Get instant guidance on bail decisions, legal provisions, and case analysis',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search by case number',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _searchCase(value);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pending Cases',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.invalidate(allCasesProvider);
                        },
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  casesAsync.when(
                    data: (cases) {
                      final pendingCases = cases
                          .where((c) => c.status == 'pending')
                          .toList();

                      if (pendingCases.isEmpty) {
                        return const Card(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.inbox,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text('No pending cases'),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: pendingCases.length,
                        itemBuilder: (context, index) {
                          final caseData = pendingCases[index];
                          return CaseCard(
                            caseNumber: caseData.caseNumber,
                            prisonerName: caseData.prisonerName,
                            status: caseData.status,
                            date: Utils.formatDate(caseData.filedDate),
                            onTap: () {
                              ref
                                  .read(currentCaseProvider.notifier)
                                  .setCase(caseData);
                              context.push(AppConstants.routeJudgeDecision);
                            },
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) =>
                        Center(child: Text('Error: $error')),
                  ),
                ],
              ),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.push('/search-case');
          },
          icon: const Icon(Icons.search),
          label: const Text('Search Case'),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  void _searchCase(String caseNumber) async {
    final caseService = ref.read(caseServiceProvider);
    final caseData = await caseService.getCaseByCaseNumber(caseNumber);

    if (caseData != null && mounted) {
      ref.read(currentCaseProvider.notifier).setCase(caseData);
      context.push(AppConstants.routeJudgeDecision);
    } else if (mounted) {
      Utils.showSnackBar(context, 'Case not found', isError: true);
    }
  }
}
