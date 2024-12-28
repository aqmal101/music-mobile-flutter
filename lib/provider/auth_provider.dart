import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  String? _authToken;

  String? get authToken => _authToken;
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  get token => null;

  Future<bool> login(String email, String password) async {
    _authToken = dotenv.env['AUTH_TOKEN'];
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final baseUrl = dotenv.env['API_URL']; // Menggunakan API_URL dari .env
    final url = '$baseUrl/api/login';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // Simpan token, role, dan nama pengguna
        await prefs.setString('token', responseData['token']);
        await prefs.setString('role', responseData['role']);
        await prefs.setString('name', responseData['user']['name']);

        notifyListeners();
        return true;
      } else {
        _errorMessage = responseData['message'] ?? 'Login gagal';
        notifyListeners();
        return false;
      }
    } catch (error) {
      _errorMessage = 'Terjadi kesalahan: $error';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String name, String email, String password,
      String confirmPassword) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final baseUrl = dotenv.env['API_URL']; // Menggunakan API_URL dari .env
    final url = '$baseUrl/api/register';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
        }),
      );

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        _errorMessage = 'Pendaftaran berhasil. Silakan login.';
        notifyListeners();
        return true;
      } else {
        if (responseData.containsKey('message')) {
          _errorMessage = responseData['message'];
        } else if (responseData.containsKey('errors')) {
          _errorMessage = (responseData['errors'] as Map<String, dynamic>)
              .values
              .map((e) => e.join(', '))
              .join('\n');
        } else {
          _errorMessage = 'Pendaftaran gagal.';
        }
        notifyListeners();
        return false;
      }
    } catch (error) {
      _errorMessage = 'Terjadi kesalahan: $error';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final baseUrl = dotenv.env['API_URL']; // Menggunakan API_URL dari .env
    final url = '$baseUrl/api/logout';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await prefs.setBool('isLoggedIn', false);
        await prefs.remove('token');
        await prefs.remove('role');
        await prefs.remove('name');
        notifyListeners();
        return true;
      } else {
        throw Exception('Logout gagal');
      }
    } catch (error) {
      _errorMessage = 'Terjadi kesalahan: $error';
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final baseUrl = dotenv.env['API_URL']; // Ambil API_URL dari .env
    final url = '$baseUrl/api/profile';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        // Ambil data user
        final userData = responseData['user'] as Map<String, dynamic>;
        final name = userData['name'] as String;
        final email = userData['email'] as String;

        // Simpan name dan email di SharedPreferences
        await prefs.setString('name', name);
        await prefs.setString('email', email);

        // Ambil playlist
        final List<dynamic> playlists = responseData['playlists'] ?? [];

        // Konversi playlist ke format List<Map<String, dynamic>>
        final List<Map<String, dynamic>> playList = playlists.map((playlist) {
          return {
            'id_playlist': playlist['id_playlist'],
            'nama_playlist': playlist['nama_playlist'],
            'img_playlist': playlist['img_playlist'],
          };
        }).toList();

        // Simpan playlist di _playList

        // Perbarui UI
        notifyListeners();

        // Kembalikan data
        return {
          'name': name,
          'email': email,
          'playlists': playList,
        };
      } else {
        // Jika respons gagal
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        _errorMessage = responseData['message'] ?? 'Gagal mengambil profil';
        notifyListeners();
        return null;
      }
    } catch (error) {
      // Jika terjadi error
      _errorMessage = 'Terjadi kesalahan: $error';
      notifyListeners();
      return null;
    }
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = dotenv.env['AUTH_TOKEN'];
    _authToken = prefs.getString('token');
    notifyListeners();
  }
}
