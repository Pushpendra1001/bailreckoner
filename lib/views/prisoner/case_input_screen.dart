import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../models/case_model.dart';
import '../../services/case_service.dart';
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

  @override
  void dispose() {
    _prisonerNameController.dispose();
    _descriptionController.dispose();
    _previousConvictionsController.dispose();
    _daysInCustodyController.dispose();
    super.dispose();
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
                        hint: 'Describe the case in detail',
                        controller: _descriptionController,
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter case description';
                          }
                          return null;
                        },
                      ),
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
