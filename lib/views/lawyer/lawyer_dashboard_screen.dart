import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../widgets/dashboard_card.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/case_controller.dart';
import '../../core/utils.dart';

class LawyerDashboardScreen extends ConsumerStatefulWidget {
  const LawyerDashboardScreen({super.key});

  @override
  ConsumerState<LawyerDashboardScreen> createState() =>
      _LawyerDashboardScreenState();
}

class _LawyerDashboardScreenState extends ConsumerState<LawyerDashboardScreen> {
  DateTime? _lastBackPress;

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
          title: const Text('Lawyer Dashboard'),
          actions: [
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
                              Icons.gavel,
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
                                  'Legal Aid Provider',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Colors.green,
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
                              'Approved',
                              cases
                                  .where((c) => c.status == 'approved')
                                  .length
                                  .toString(),
                              Icons.check_circle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    loading: () => const SizedBox(),
                    error: (_, __) => const SizedBox(),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Client Services',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      DashboardCard(
                        title: 'New Client Case',
                        subtitle: 'Add client details',
                        icon: Icons.person_add,
                        onTap: () {
                          ref.read(currentCaseProvider.notifier).clearCase();
                          context.push(AppConstants.routeCaseInput);
                        },
                      ),
                      DashboardCard(
                        title: 'All Cases',
                        subtitle: 'View client cases',
                        icon: Icons.folder_open,
                        onTap: () {
                          context.push('/case-list');
                        },
                      ),
                      DashboardCard(
                        title: 'Generate Application',
                        subtitle: 'AI-powered drafts',
                        icon: Icons.description,
                        onTap: () {
                          final currentCase = ref.read(currentCaseProvider);
                          if (currentCase != null) {
                            context.push(AppConstants.routeBailGenerator);
                          } else {
                            Utils.showSnackBar(
                              context,
                              'Please create a case first',
                              isError: true,
                            );
                          }
                        },
                      ),
                      DashboardCard(
                        title: 'Documents',
                        subtitle: 'Required docs list',
                        icon: Icons.article,
                        onTap: () {
                          context.push('/documents');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
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
}
