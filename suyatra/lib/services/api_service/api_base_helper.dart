import 'package:http/http.dart' as http;

class ApiBaseHelper {
  Future<http.Response> getWithoutToken(String url) async {
    try {
      Map<String, String> headers = {
        "Content-Type": "application/json"
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      return response;
    } catch(exception) {
      rethrow;
    }
  }
}