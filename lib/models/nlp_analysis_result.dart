class NLPAnalysisResult {
  final List<String> extractedCharges;
  final List<String> extractedSections;
  final String crimeCategory;
  final List<String> riskFactors;
  final String? criminalHistory;
  final double confidence;

  NLPAnalysisResult({
    required this.extractedCharges,
    required this.extractedSections,
    required this.crimeCategory,
    required this.riskFactors,
    this.criminalHistory,
    required this.confidence,
  });

  Map<String, dynamic> toJson() => {
    'extractedCharges': extractedCharges,
    'extractedSections': extractedSections,
    'crimeCategory': crimeCategory,
    'riskFactors': riskFactors,
    'criminalHistory': criminalHistory,
    'confidence': confidence,
  };

  factory NLPAnalysisResult.fromJson(Map<String, dynamic> json) =>
      NLPAnalysisResult(
        extractedCharges: List<String>.from(json['extractedCharges']),
        extractedSections: List<String>.from(json['extractedSections']),
        crimeCategory: json['crimeCategory'] as String,
        riskFactors: List<String>.from(json['riskFactors']),
        criminalHistory: json['criminalHistory'] as String?,
        confidence: (json['confidence'] as num).toDouble(),
      );
}
