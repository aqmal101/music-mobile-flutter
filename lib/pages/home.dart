import 'package:flutter/material.dart';
import 'package:music_app/provider/auth_provider.dart';
import 'package:music_app/provider/music_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _name = '';
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadProfile();
    _fetchMusics(); // Fetch the music data when the page loads
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final loginProvider = Provider.of<AuthProvider>(context, listen: false);
    final profile = await loginProvider.getProfile();

    if (profile != null) {
      setState(() {
        _name = profile['name']!;
      });
    }
  }

  Future<void> _fetchMusics() async {
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    await musicProvider.fetchMusics();
  }

  @override
  Widget build(BuildContext context) {
    final musicProvider = Provider.of<MusicProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Hi, $_name! 👋',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Music',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                Icon(Icons.music_note_rounded, color: Colors.white),
              ],
            ),
          ),
          Expanded(
            child: musicProvider.getIsLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 200),
                    controller: _scrollController,
                    itemCount: musicProvider.getMusics.length,
                    itemBuilder: (context, index) {
                      final music = musicProvider.getMusics[index];
                      return ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              border: Border.all(color: Colors.orange),
                            ),
                            child: Image.network(music.fileAlbumUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.network(
                                        'https://cdn.pixabay.com/photo/2019/08/11/18/27/icon-4399630_1280.png')),
                          ),
                        ),
                        title: Text(
                          music.judul,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          music.artis,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                          icon:
                              const Icon(Icons.play_arrow, color: Colors.white),
                          onPressed: () {
                            // Add music playback logic here
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
