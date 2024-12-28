import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:music_app/models/music.dart';

class MusicProvider with ChangeNotifier {
  List<Music> musics = [];
  bool _isLoading = false;

  List<Music> get getMusics => musics;
  bool get getIsLoading => _isLoading;

  String errorMessage = '';

  Future<void> fetchMusics() async {
    _isLoading = true;
    notifyListeners();
    final baseUrl = dotenv.env['API_URL'];

    final url = '$baseUrl/api/musics';

    try {
      final response = await http.get(Uri.parse(url));

      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          final List<dynamic> data = responseData['data'];
          musics = data.map((item) => Music.fromJson(item)).toList();
        } else {
          errorMessage = 'Failed to parse music data';
        }
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
