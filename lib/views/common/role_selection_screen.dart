import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../widgets/dashboard_card.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Icon(
                  Icons.balance,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select Your Role',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 60),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 1,
                    mainAxisSpacing: 20,
                    childAspectRatio: 2.5,
                    children: [
                      DashboardCard(
                        title: 'Undertrial Prisoner',
                        subtitle: 'Check bail eligibility and apply',
                        icon: Icons.person,
                        color: Colors.blue.withValues(alpha: 0.2),
                        onTap: () =>
                            context.go(AppConstants.routePrisonerLogin),
                      ),
                      DashboardCard(
                        title: 'Legal Aid Provider',
                        subtitle: 'Assist clients with bail applications',
                        icon: Icons.gavel,
                        color: Colors.green.withValues(alpha: 0.2),
                        onTap: () => context.go(AppConstants.routeLawyerLogin),
                      ),
                      DashboardCard(
                        title: 'Judicial Authority',
                        subtitle: 'Review and decide bail cases',
                        icon: Icons.account_balance,
                        color: Colors.purple.withValues(alpha: 0.2),
                        onTap: () => context.go(AppConstants.routeJudgeLogin),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
