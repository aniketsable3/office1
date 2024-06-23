import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2/office1/";

  static Future<List<dynamic>> fetchNotes() async {
    final response = await http.get(Uri.parse("$baseUrl/fetch_notes.php"));
    return json.decode(response.body);
  }

  static Future<bool> insertNote(String title, String description, String sdate, String edate) async {
    final response = await http.post(
      Uri.parse("$baseUrl/insert_note.php"),
      body: {
        'title': title,
        'description': description,
        'sdate': sdate,
        'edate': edate,
      },
    );
    return json.decode(response.body)['success'];
  }

  static Future<bool> updateNote(int sno, String title, String description, String sdate, String edate) async {
    final response = await http.post(
      Uri.parse("$baseUrl/update_note.php"),
      body: {
        'sno': sno.toString(),
        'title': title,
        'description': description,
        'sdate': sdate,
        'edate': edate,
      },
    );
    return json.decode(response.body)['success'];
  }

  static Future<bool> deleteNote(int sno) async {
    final response = await http.post(
      Uri.parse("$baseUrl/delete_note.php"),
      body: {'sno': sno.toString()},
    );
    return json.decode(response.body)['success'];
  }
}
