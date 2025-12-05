class RiskAnalysis {
  final double riskScore;
  final String riskLevel;
  final List<String> highRiskFactors;
  final List<String> missingDocuments;
  final String recommendation;
  final String suggestedAction;

  RiskAnalysis({
    required this.riskScore,
    required this.riskLevel,
    required this.highRiskFactors,
    required this.missingDocuments,
    required this.recommendation,
    required this.suggestedAction,
  });

  Map<String, dynamic> toJson() => {
    'riskScore': riskScore,
    'riskLevel': riskLevel,
    'highRiskFactors': highRiskFactors,
    'missingDocuments': missingDocuments,
    'recommendation': recommendation,
    'suggestedAction': suggestedAction,
  };

  factory RiskAnalysis.fromJson(Map<String, dynamic> json) => RiskAnalysis(
    riskScore: (json['riskScore'] as num).toDouble(),
    riskLevel: json['riskLevel'] as String,
    highRiskFactors: List<String>.from(json['highRiskFactors']),
    missingDocuments: List<String>.from(json['missingDocuments']),
    recommendation: json['recommendation'] as String,
    suggestedAction: json['suggestedAction'] as String,
  );
}
