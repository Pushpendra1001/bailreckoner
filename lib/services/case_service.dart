import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/case_model.dart';
import 'package:uuid/uuid.dart';

class CaseService {
  static const String _keyCases = 'cases';

  Future<List<CaseModel>> getAllCases() async {
    final prefs = await SharedPreferences.getInstance();
    final casesJson = prefs.getStringList(_keyCases) ?? [];
    return casesJson
        .map((json) => CaseModel.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> saveCase(CaseModel caseModel) async {
    final prefs = await SharedPreferences.getInstance();
    final cases = await getAllCases();
    cases.add(caseModel);
    final casesJson = cases.map((c) => jsonEncode(c.toJson())).toList();
    await prefs.setStringList(_keyCases, casesJson);
  }

  Future<void> updateCase(CaseModel caseModel) async {
    final prefs = await SharedPreferences.getInstance();
    final cases = await getAllCases();
    final index = cases.indexWhere((c) => c.id == caseModel.id);
    if (index != -1) {
      cases[index] = caseModel;
      final casesJson = cases.map((c) => jsonEncode(c.toJson())).toList();
      await prefs.setStringList(_keyCases, casesJson);
    }
  }

  Future<CaseModel?> getCaseById(String id) async {
    final cases = await getAllCases();
    try {
      return cases.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<CaseModel?> getCaseByCaseNumber(String caseNumber) async {
    final cases = await getAllCases();
    try {
      return cases.firstWhere((c) => c.caseNumber == caseNumber);
    } catch (e) {
      return null;
    }
  }

  String generateCaseNumber() {
    final now = DateTime.now();
    final random = const Uuid().v4().substring(0, 4).toUpperCase();
    return 'CASE/${now.year}/$random';
  }
}
