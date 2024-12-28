import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/playlist.dart';

class PlaylistProvider with ChangeNotifier {
  List<Playlist> _playlistList = [];
  bool _isLoading = false;

  List<Playlist> get playlistList => _playlistList;
  bool get isLoading => _isLoading;

  // Load environment variables from .env
  final String baseUrl = 'http://127.0.0.1:8000/api';

  Future<void> fetchPlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    _isLoading = true;
    notifyListeners();

    final url = '$baseUrl/playlists'; // Example endpoint for playlists
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('ini adalah playlist saya');
        print(responseData);
        print('ini adalah playlist saya');
        if (responseData['status'] == 'success') {
          final List<dynamic> data = responseData['data'];
          _playlistList = data.map((item) => Playlist.fromJson(item)).toList();
          print('ini adalah playlist');
          print(_playlistList);
          print('ini adalah playlist');
        }
      } else {
        print('Failed to fetch playlists: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching playlists: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addPlaylist({
    required String namaPlaylist,
    required String imgPlaylist,
    required String imgUrl, // You can use this URL if needed for other purposes
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = '$baseUrl/playlists';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'nama_playlist': namaPlaylist,
          'img_playlist': imgUrl, // Use the imgUrl parameter here
        }),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['status'] == 'success') {
        await fetchPlaylists(); // Fetch updated list
        return true;
      } else {
        print('Error: ${responseData['message']}');
        return false;
      }
    } catch (error) {
      print('Error adding playlist: $error');
      return false;
    }
  }

  Future<bool> editPlaylist({
    required String id,
    required String namaPlaylist,
    required String imgPlaylist,
  }) async {
    final url = '$baseUrl/playlists'; // Example endpoint for updating playlists
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': id,
          'nama_playlist': namaPlaylist,
          'img_playlist': imgPlaylist,
        }),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['status'] == 'success') {
        // Refresh data playlists after editing
        await fetchPlaylists();
        return true;
      } else {
        print('Error: ${responseData['message']}');
        return false;
      }
    } catch (error) {
      print('Error editing playlist: $error');
      return false;
    }
  }

  Future<bool> deletePlaylist(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url =
        '$baseUrl/playlists/$id'; // Example endpoint for deleting playlists
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          // Refresh data playlists after deleting
          await fetchPlaylists();
          return true;
        } else {
          print('Error: ${responseData['message']}');
          return false;
        }
      } else {
        print('Failed to delete playlist: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error deleting playlist: $error');
      return false;
    }
  }
}
