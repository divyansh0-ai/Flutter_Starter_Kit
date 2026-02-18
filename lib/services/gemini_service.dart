import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel _model;
  final String apiKey;

  GeminiService(this.apiKey) {
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  }

  Future<String?> getVisualInstruction(String query) async {
    final prompt =
        '''
    You are a Liquid Galaxy Agent. The user wants to see: "$query".
    Provide a JSON response with the following fields:
    - location_name: A descriptive name of the place.
    - latitude: Double.
    - longitude: Double.
    - zoom: Double (typically 1000 to 5000000).
    - fun_fact: A short fact about the place.

    Respond ONLY with the JSON.
    ''';

    final content = [Content.text(prompt)];
    try {
      final response = await _model.generateContent(content);
      return response.text;
    } catch (e) {
      debugPrint('Gemini error: $e');
      return null;
    }
  }
}
