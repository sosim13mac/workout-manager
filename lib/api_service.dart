import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "https://integrate.api.nvidia.com/v1/chat/completions";
  static const String _apiKey = "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";
  static const String _modelId = "nvidia/nemotron-3-super-120b-a12b";

  Future<String> analyzeFood(String description) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_apiKey",
        },
        body: jsonEncode({
          "model": _modelId,
          "messages": [
            {
              "role": "user",
              "content": "다음 음식의 칼로리와 영양 성분을 분석해줘: $description. 답변은 반드시 한국어로 해줘."
            }
          ],
          "temperature": 0.5,
          "max_tokens": 1024,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'];
      } else {
        return "에러 발생: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      return "분석 중 오류가 발생했습니다: $e";
    }
  }
}
