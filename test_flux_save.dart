import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

void main() async {
  final apiKey = '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';
  final dio = Dio(BaseOptions(
    baseUrl: 'https://ai.api.nvidia.com/v1/genai',
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  ));

  try {
    print('Sending request...');
    final response = await dio.post(
      '/black-forest-labs/flux.1-schnell',
      data: {
        'prompt': 'A beautiful scenic landscape with mountains and a river, vibrant colors',
        'seed': 0,
        'steps': 4,
        'width': 1344,
        'height': 1024,
      },
    );
    print('Status: ${response.statusCode}');
    final artifacts = response.data['artifacts'] ?? [];
    if (artifacts.isNotEmpty) {
      final base64Image = artifacts[0]['base64'];
      print('Got base64, length: ${base64Image.length}');
      final bytes = base64Decode(base64Image);
      final file = File('test_image_1344.png');
      await file.writeAsBytes(bytes);
      print('Saved to test_image_1344.png');
    } else {
      print('No artifacts');
    }
  } catch (e) {
    print('Error: $e');
  }
}
