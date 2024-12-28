import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music_app/pages/intro.dart';
import 'package:music_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = '';
  String _email = '';
  List<Map<String, dynamic>> _playlists = [];
  final String _profilePic =
      'https://raw.githubusercontent.com/aqmal101/background-image/refs/heads/main/%CA%9A%C9%9E.jpeg';
  // 'https://doodleipsum.com/80x80/avatar-2?i=f7402920909e99b3850e78f13a950f42';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final profile = await authProvider.getProfile();

      if (profile != null) {
        setState(() {
          _name = profile['name'];
          _email = profile['email'];
          _playlists = profile['playlists'] != null
              ? List<Map<String, dynamic>>.from(profile['playlists'])
              : [];
        });
      }
    } catch (e) {
      // Handle error when fetching profile
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
  }

  Future<void> _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.logout();

    if (success) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const IntroScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 0, 251, 255),
              Color(0xFF121212),
              Color(0xFF121212),
              Color(0xFF121212),
              Color(0xFF121212),
              Color(0xFF121212),
            ],
          ),
        ),
        padding:
            const EdgeInsets.only(top: 20, right: 16, left: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Header Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        _profilePic,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _name,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _email,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text('My Playlists',
                style: TextStyle(color: Colors.white, fontSize: 16)),
            // const SizedBox(height: 10),
            // Playlists List Section
            Expanded(
              child: _playlists.isEmpty
                  ? const Center(
                      child: Text(
                        'No playlists found',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _playlists.length,
                      itemBuilder: (context, index) {
                        final playlist = _playlists[index];

                        // Ambil URL gambar dengan base URL
                        final imageUrl = playlist['img_playlist'] != null
                            ? 'http://127.0.0.1:8000${playlist['img_playlist']}'
                            : 'https://via.placeholder.com/150'; // Gambar fallback

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                ),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.playlist_play_sharp,
                                        color: Colors.orange);
                                  },
                                )),
                            title: Text(
                              playlist['nama_playlist'] ?? 'Unnamed Playlist',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
