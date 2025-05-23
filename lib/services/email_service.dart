import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  static const String _serviceId = 'service_rh2gp8n';
  static const String _templateId = 'template_51x34cm';
  static const String _publicKey = 'fZURuS40wX5VDNNOw';
  
  static Future<bool> sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _publicKey,
          'template_params': {
            'from_name': name,
            'from_email': email,
            'subject': subject,
            'message': message,
            'to_email': 'swapnaneelsarkar571@gmail.com',
          },
        }),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('Error sending email: $e');
      return false;
    }
  }
}
