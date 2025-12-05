import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../models/case_model.dart';
import '../../services/case_service.dart';
import '../../services/ai_service.dart';
import '../../controllers/case_controller.dart';
import '../../controllers/ai_controller.dart';

class CaseInputScreen extends ConsumerStatefulWidget {
  const CaseInputScreen({super.key});

  @override
  ConsumerState<CaseInputScreen> createState() => _CaseInputScreenState();
}

class _CaseInputScreenState extends ConsumerState<CaseInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prisonerNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _previousConvictionsController = TextEditingController(text: '0');
  final _daysInCustodyController = TextEditingController(text: '0');

  String _selectedCrimeCategory = AppConstants.crimeCategories[0];
  final List<String> _selectedSections = [];
  bool _isAnalyzing = false;
  bool _isAutoDetecting = false;
  String _detectedCategory = '';
  List<String> _suggestedSections = [];

  @override
  void dispose() {
    _prisonerNameController.dispose();
    _descriptionController.dispose();
    _previousConvictionsController.dispose();
    _daysInCustodyController.dispose();
    super.dispose();
  }

  Future<void> _autoDetectIPCSections() async {
    final description = _descriptionController.text.trim();
    if (description.length < 20) return;

    setState(() => _isAutoDetecting = true);

    try {
      final aiService = AIService();
      final analysis = await aiService.analyzeCaseNLP(description);

      setState(() {
        _suggestedSections = analysis.extractedSections;
        _detectedCategory = analysis.crimeCategory;

        // Auto-select suggested sections
        _selectedSections.clear();
        for (final section in analysis.extractedSections) {
          // Map detected sections to available IPC sections
          if (section.contains('379'))
            _selectedSections.add('Section 379 - Theft');
          if (section.contains('420'))
            _selectedSections.add('Section 420 - Cheating');
          if (section.contains('302'))
            _selectedSections.add('Section 302 - Murder');
          if (section.contains('323'))
            _selectedSections.add('Section 323 - Assault');
          if (section.contains('392'))
            _selectedSections.add('Section 392 - Robbery');
          if (section.contains('376'))
            _selectedSections.add('Section 376 - Rape');
          if (section.contains('363'))
            _selectedSections.add('Section 363 - Kidnapping');
          if (section.contains('465') || section.contains('463'))
            _selectedSections.add('Section 465 - Forgery');
        }

        // Update crime category if detected
        if (_detectedCategory.isNotEmpty &&
            AppConstants.crimeCategories.contains(_detectedCategory)) {
          _selectedCrimeCategory = _detectedCategory;
        }
      });

      if (mounted && _suggestedSections.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ Auto-detected: ${_suggestedSections.join(', ')}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Silent fail - user can manually select
    } finally {
      if (mounted) {
        setState(() => _isAutoDetecting = false);
      }
    }
  }

  Future<void> _analyzeCase() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedSections.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one IPC section'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() => _isAnalyzing = true);

      try {
        final caseService = CaseService();
        final caseNumber = caseService.generateCaseNumber();

        final caseModel = CaseModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          caseNumber: caseNumber,
          prisonerName: _prisonerNameController.text,
          description: _descriptionController.text,
          charges: [],
          ipcSections: _selectedSections,
          crimeCategory: _selectedCrimeCategory,
          previousConvictions: int.parse(_previousConvictionsController.text),
          daysInCustody: int.parse(_daysInCustodyController.text),
          filedDate: DateTime.now(),
          status: 'pending',
        );

        ref.read(currentCaseProvider.notifier).setCase(caseModel);
        await caseService.saveCase(caseModel);

        await ref
            .read(nlpAnalysisProvider.notifier)
            .analyzeCase(_descriptionController.text);

        if (mounted) {
          context.push(AppConstants.routeNLPAnalysis);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isAnalyzing = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isAnalyzing,
      child: Scaffold(
        appBar: AppBar(title: const Text('Enter Case Details')),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final padding = constraints.maxWidth > 600 ? 32.0 : 16.0;
              return SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        label: 'Prisoner Name',
                        hint: 'Full name',
                        controller: _prisonerNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter prisoner name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Case Description',
                        hint:
                            'Describe the case in detail (theft, assault, fraud, etc.)',
                        controller: _descriptionController,
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter case description';
                          }
                          if (value.length < 20) {
                            return 'Please provide more details (at least 20 characters)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _isAutoDetecting
                            ? null
                            : _autoDetectIPCSections,
                        icon: _isAutoDetecting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.auto_fix_high),
                        label: Text(
                          _isAutoDetecting
                              ? 'Detecting...'
                              : 'Auto-Detect IPC Sections',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      if (_suggestedSections.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Card(
                          color: Colors.green.withValues(alpha: 0.1),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Detected: ${_suggestedSections.join(', ')}',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCrimeCategory,
                        decoration: const InputDecoration(
                          labelText: 'Crime Category',
                        ),
                        items: AppConstants.crimeCategories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedCrimeCategory = value!);
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'IPC Sections',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: AppConstants.ipcSections.map((section) {
                          final isSelected = _selectedSections.contains(
                            section,
                          );
                          return FilterChip(
                            label: Text(section),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedSections.add(section);
                                } else {
                                  _selectedSections.remove(section);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Previous Convictions',
                        hint: '0',
                        controller: _previousConvictionsController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter number of previous convictions';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Days in Custody',
                        hint: '0',
                        controller: _daysInCustodyController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter days in custody';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        text: 'Analyze Case',
                        onPressed: _analyzeCase,
                        isLoading: _isAnalyzing,
                        icon: Icons.analytics,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
