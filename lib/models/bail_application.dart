class BailApplication {
  final String caseNumber;
  final String courtName;
  final String applicantName;
  final String summary;
  final String legalReasoning;
  final String arguments;
  final String mitigationFactors;
  final DateTime generatedDate;

  BailApplication({
    required this.caseNumber,
    required this.courtName,
    required this.applicantName,
    required this.summary,
    required this.legalReasoning,
    required this.arguments,
    required this.mitigationFactors,
    required this.generatedDate,
  });

  Map<String, dynamic> toJson() => {
    'caseNumber': caseNumber,
    'courtName': courtName,
    'applicantName': applicantName,
    'summary': summary,
    'legalReasoning': legalReasoning,
    'arguments': arguments,
    'mitigationFactors': mitigationFactors,
    'generatedDate': generatedDate.toIso8601String(),
  };

  factory BailApplication.fromJson(Map<String, dynamic> json) =>
      BailApplication(
        caseNumber: json['caseNumber'] as String,
        courtName: json['courtName'] as String,
        applicantName: json['applicantName'] as String,
        summary: json['summary'] as String,
        legalReasoning: json['legalReasoning'] as String,
        arguments: json['arguments'] as String,
        mitigationFactors: json['mitigationFactors'] as String,
        generatedDate: DateTime.parse(json['generatedDate'] as String),
      );
}
