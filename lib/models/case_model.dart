class CaseModel {
  final String id;
  final String caseNumber;
  final String prisonerName;
  final String description;
  final List<String> charges;
  final List<String> ipcSections;
  final String crimeCategory;
  final int previousConvictions;
  final int daysInCustody;
  final String? criminalHistory;
  final DateTime filedDate;
  final String status;
  final String? lawyerId;
  final String? judgeId;

  CaseModel({
    required this.id,
    required this.caseNumber,
    required this.prisonerName,
    required this.description,
    required this.charges,
    required this.ipcSections,
    required this.crimeCategory,
    required this.previousConvictions,
    required this.daysInCustody,
    this.criminalHistory,
    required this.filedDate,
    required this.status,
    this.lawyerId,
    this.judgeId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'caseNumber': caseNumber,
    'prisonerName': prisonerName,
    'description': description,
    'charges': charges,
    'ipcSections': ipcSections,
    'crimeCategory': crimeCategory,
    'previousConvictions': previousConvictions,
    'daysInCustody': daysInCustody,
    'criminalHistory': criminalHistory,
    'filedDate': filedDate.toIso8601String(),
    'status': status,
    'lawyerId': lawyerId,
    'judgeId': judgeId,
  };

  factory CaseModel.fromJson(Map<String, dynamic> json) => CaseModel(
    id: json['id'] as String,
    caseNumber: json['caseNumber'] as String,
    prisonerName: json['prisonerName'] as String,
    description: json['description'] as String,
    charges: List<String>.from(json['charges']),
    ipcSections: List<String>.from(json['ipcSections']),
    crimeCategory: json['crimeCategory'] as String,
    previousConvictions: json['previousConvictions'] as int,
    daysInCustody: json['daysInCustody'] as int,
    criminalHistory: json['criminalHistory'] as String?,
    filedDate: DateTime.parse(json['filedDate'] as String),
    status: json['status'] as String,
    lawyerId: json['lawyerId'] as String?,
    judgeId: json['judgeId'] as String?,
  );
}
