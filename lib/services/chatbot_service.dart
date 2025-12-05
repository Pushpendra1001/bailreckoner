import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/constants.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatbotService {
  late final GenerativeModel _model;
  final List<Content> _chatHistory = [];

  ChatbotService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: AppConstants.geminiApiKey,
      generationConfig: GenerationConfig(
        temperature: 0.8,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
      systemInstruction: Content.system('''
You are a legal AI assistant specialized in Indian judicial system and bail procedures.

STRICT GUIDELINES:
- Only provide information related to: Indian Penal Code (IPC), Criminal Procedure Code (CrPC), bail procedures, legal precedents, and judicial matters
- DO NOT provide: Medical advice, financial advice, personal counseling, or any non-legal information
- If asked non-legal questions, politely redirect: "I can only assist with legal and judicial matters related to bail and Indian law."
- Provide accurate, professional legal information
- Cite relevant sections when applicable
- Be concise but comprehensive
- Use simple language for complex legal concepts

Your role: Help judges, lawyers, and legal professionals make informed decisions about bail cases.
'''),
    );
  }

  Future<String> sendMessage(String userMessage, String userRole) async {
    try {
      // Add context based on user role
      String contextualizedMessage = userMessage;

      if (userRole == 'judge') {
        contextualizedMessage =
            '''
As a judicial authority reviewing bail applications, I need guidance on: $userMessage

Please provide:
1. Relevant legal provisions
2. Key considerations for bail decision
3. Precedents if applicable
4. Risk factors to evaluate
''';
      } else if (userRole == 'lawyer') {
        contextualizedMessage =
            '''
As a legal aid provider representing clients in bail matters, I need information about: $userMessage

Please help me understand:
1. Legal strategies available
2. Relevant case laws
3. Documents required
4. Arguments that strengthen bail application
''';
      }

      // Add user message to history
      _chatHistory.add(Content.text(contextualizedMessage));

      // Generate response
      final response = await _model.generateContent(_chatHistory);
      final botResponse =
          response.text ??
          'I apologize, I could not generate a response. Please try rephrasing your question.';

      // Add bot response to history
      _chatHistory.add(Content.model([TextPart(botResponse)]));

      return botResponse;
    } catch (e) {
      return 'Error: ${e.toString()}. Please check your connection and try again.';
    }
  }

  void clearHistory() {
    _chatHistory.clear();
  }

  List<Content> getHistory() {
    return List.unmodifiable(_chatHistory);
  }
}
