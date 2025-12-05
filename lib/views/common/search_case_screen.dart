import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../controllers/case_controller.dart';
import '../../widgets/custom_button.dart';

class SearchCaseScreen extends ConsumerStatefulWidget {
  const SearchCaseScreen({super.key});

  @override
  ConsumerState<SearchCaseScreen> createState() => _SearchCaseScreenState();
}

class _SearchCaseScreenState extends ConsumerState<SearchCaseScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  String? _errorMessage;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchCase() async {
    final caseNumber = _searchController.text.trim();

    if (caseNumber.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a case number';
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _errorMessage = null;
    });

    try {
      final caseService = ref.read(caseServiceProvider);
      final caseData = await caseService.getCaseByCaseNumber(caseNumber);

      if (caseData != null && mounted) {
        ref.read(currentCaseProvider.notifier).setCase(caseData);
        context.push(AppConstants.routeJudgeDecision);
      } else {
        setState(() {
          _errorMessage = 'Case not found. Please check the case number.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Case')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = constraints.maxWidth > 600 ? 32.0 : 16.0;
            return SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  Icon(
                    Icons.search,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Search for Case',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter case number to view details',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Case Number',
                      hintText: 'e.g., CASE/2025/XXXX',
                      prefixIcon: const Icon(Icons.folder),
                      border: const OutlineInputBorder(),
                      errorText: _errorMessage,
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _searchCase(),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Search',
                    onPressed: _searchCase,
                    isLoading: _isSearching,
                    icon: Icons.search,
                  ),
                  const SizedBox(height: 16),
                  if (_errorMessage != null)
                    Card(
                      color: Colors.red.withValues(alpha: 0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
