import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../widgets/dashboard_card.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/case_controller.dart';
import '../../core/utils.dart';

class PrisonerDashboardScreen extends ConsumerStatefulWidget {
  const PrisonerDashboardScreen({super.key});

  @override
  ConsumerState<PrisonerDashboardScreen> createState() =>
      _PrisonerDashboardScreenState();
}

class _PrisonerDashboardScreenState
    extends ConsumerState<PrisonerDashboardScreen> {
  DateTime? _lastBackPress;

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);

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
          title: const Text('Prisoner Dashboard'),
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
                              Icons.person,
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'What would you like to do?',
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
                        title: 'New Case',
                        subtitle: 'Enter case details',
                        icon: Icons.add_circle,
                        onTap: () {
                          ref.read(currentCaseProvider.notifier).clearCase();
                          context.push(AppConstants.routeCaseInput);
                        },
                      ),
                      DashboardCard(
                        title: 'My Cases',
                        subtitle: 'View all cases',
                        icon: Icons.folder,
                        onTap: () {
                          context.push('/case-list');
                        },
                      ),
                      DashboardCard(
                        title: 'Check Eligibility',
                        subtitle: 'Predict bail chance',
                        icon: Icons.analytics,
                        onTap: () {
                          final currentCase = ref.read(currentCaseProvider);
                          if (currentCase != null) {
                            context.push(
                              AppConstants.routeEligibilityPrediction,
                            );
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
                        title: 'Notifications',
                        subtitle: 'View updates',
                        icon: Icons.notifications,
                        onTap: () =>
                            context.push(AppConstants.routeNotifications),
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
}
