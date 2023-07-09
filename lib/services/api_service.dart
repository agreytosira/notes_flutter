import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes_flutter/utils/constants.dart';
import '../models/notes.dart';
import '../models/api_response.dart';

class ApiService {
  static const notesUrl = '${Constants.baseUrl}/notes';

  static Future<List<Notes>> fetchNotes() async {
    final response = await http.get(Uri.parse("$notesUrl"));
    // print("Request Endpoint : $notesUrl");
    if (response.statusCode == 200) {
      // print("Response : ${response.body}");
      final data = json.decode(response.body);
      final notesData = data['data'] as List<dynamic>;
      return notesData.map((notes) => Notes.fromJson(notes)).toList();
    } else {
      throw Exception('Failed to fetch notes');
    }
  }

  static Future<Notes> fetchOneNote({required id}) async {
    final response = await http.get(Uri.parse("$notesUrl/$id"));
    print("Request Endpoint : $notesUrl/$id");
    if (response.statusCode == 200) {
      print("Response : ${response.body}");
      final data = json.decode(response.body);
      if (data['status'] == 1) {
        final notesData = data['data'];
        return Notes.fromJson(notesData);
      } else {
        throw Exception('Failed to fetch notes: ${data['message']}');
      }
    } else {
      throw Exception('Failed to fetch notes');
    }
  }

  static Future<ApiResponse> updateNote(
      {required id, required title, required content}) async {
    final body = {'title': title, 'content': content};

    final response = await http.put(Uri.parse("$notesUrl/$id"), body: body);
    print("Request Endpoint : $notesUrl/$id");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 1) {
        return ApiResponse(
            status: data['status'],
            data: data['data'],
            message: data['message']);
      } else {
        throw Exception('Failed to fetch notes: ${data['message']}');
      }
    } else {
      throw Exception('Failed to update note');
    }
  }

  static Future<ApiResponse> deleteNote({required id}) async {
    final response = await http.delete(Uri.parse("$notesUrl/$id"));
    print("Request Endpoint Update : $notesUrl/$id");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 1) {
        return ApiResponse(
            status: data['status'],
            data: data['data'],
            message: data['message']);
      } else {
        throw Exception('Failed to fetch notes: ${data['message']}');
      }
    } else {
      throw Exception('Failed to update note');
    }
  }

  static Future<ApiResponse> insertNote(
      {required title, required content}) async {
    final body = {'title': title, 'content': content};

    final response = await http.post(Uri.parse("$notesUrl"), body: body);
    print("Request Endpoint : $notesUrl");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 1) {
        return ApiResponse(
            status: data['status'],
            data: data['data'],
            message: data['message']);
      } else {
        throw Exception('Failed to fetch notes: ${data['message']}');
      }
    } else {
      throw Exception('Failed to insert note');
    }
  }
}
