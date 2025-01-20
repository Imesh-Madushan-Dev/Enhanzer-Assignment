import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final String apiUrl = dotenv.env['API_URL'] ?? '';

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'API_Body': [
            {'Unique_Id': '', 'Pw': password}
          ],
          'Api_Action': 'GetUserData',
          'Company_Code': username
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['Status_Code'] == 200) {
          return {'success': true, 'data': data['Response_Body'][0]};
        } else {
          return {
            'success': false,
            'message': data['Message'] ?? 'Login failed'
          };
        }
      } else {
        return {'success': false, 'message': 'Server error'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
}
