class EligibilityPrediction {
  final double probabilityScore;
  final String recommendation;
  final String explanation;
  final List<String> favorableFactors;
  final List<String> unfavorableFactors;
  final List<String> requiredDocuments;

  EligibilityPrediction({
    required this.probabilityScore,
    required this.recommendation,
    required this.explanation,
    required this.favorableFactors,
    required this.unfavorableFactors,
    required this.requiredDocuments,
  });

  Map<String, dynamic> toJson() => {
    'probabilityScore': probabilityScore,
    'recommendation': recommendation,
    'explanation': explanation,
    'favorableFactors': favorableFactors,
    'unfavorableFactors': unfavorableFactors,
    'requiredDocuments': requiredDocuments,
  };

  factory EligibilityPrediction.fromJson(Map<String, dynamic> json) =>
      EligibilityPrediction(
        probabilityScore: (json['probabilityScore'] as num).toDouble(),
        recommendation: json['recommendation'] as String,
        explanation: json['explanation'] as String,
        favorableFactors: List<String>.from(json['favorableFactors']),
        unfavorableFactors: List<String>.from(json['unfavorableFactors']),
        requiredDocuments: List<String>.from(json['requiredDocuments']),
      );
}
