import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const apiKey = 'AIzaSyApYvFQrAPKGEdDuCBJ8Rp2AcQ39OlPvT0';

  try {
    print('🤖 Testing Gemini API...');

    // Test with gemini-1.5-flash model
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    final response = await model.generateContent([
      Content.text('Hello, this is a test message.'),
    ]);

    print('✅ Success! Response: ${response.text}');
  } catch (e) {
    print('❌ Error: $e');

    // Try with gemini-pro model as fallback
    try {
      print('🔄 Trying with gemini-pro model...');
      final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
      final response = await model.generateContent([
        Content.text('Hello, this is a test message.'),
      ]);

      print('✅ Success with gemini-pro! Response: ${response.text}');
    } catch (e2) {
      print('❌ Both models failed. Error: $e2');
    }
  }
}
