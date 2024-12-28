import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/models/music.dart';
import 'package:music_app/pages/home.dart';
import 'package:music_app/pages/library.dart';
import 'package:music_app/pages/profile.dart';
import 'package:music_app/provider/music_provider.dart';
import 'package:music_app/widgets/scrolling_text.dart';
import 'package:provider/provider.dart';

class BasePage extends StatelessWidget {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  late ConcatenatingAudioSource _playlistSource;
  int _currentIndexInPlaylist = 0;

  List<Music> _playlist = []; // Dynamic playlist
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _fetchMusics(); // Fetch the music data when the page loads
    _listenToPosition();
  }

  Future<void> _fetchMusics() async {
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    await musicProvider.fetchMusics();

    setState(() {
      _playlist = musicProvider.musics; // Assume musics is a List<Music>
      _initializePlaylist();
      _isLoading = false;
    });
  }

  Future<void> _initializePlaylist() async {
    if (_playlist.isEmpty) return;

    _playlistSource = ConcatenatingAudioSource(
      children: _playlist
          .map((music) => AudioSource.uri(Uri.parse(music.fileMusicUrl)))
          .toList(),
    );

    try {
      await _audioPlayer.setAudioSource(_playlistSource,
          initialIndex: _currentIndexInPlaylist);
      setState(() {
        _totalDuration = _audioPlayer.duration ?? Duration.zero;
      });
    } catch (e) {
      debugPrint("Failed to load playlist: $e");
    }
  }

  void _listenToPosition() {
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _audioPlayer.pause();
      } else {
        _audioPlayer.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  void _nextTrack() {
    if (_currentIndexInPlaylist < _playlist.length - 1) {
      setState(() {
        _currentIndexInPlaylist++;
      });
      _audioPlayer.seekToNext();
    }
  }

  void _previousTrack() {
    if (_currentIndexInPlaylist > 0) {
      setState(() {
        _currentIndexInPlaylist--;
      });
      _audioPlayer.seekToPrevious();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isFirstTrack = _currentIndexInPlaylist == 0;
    bool isLastTrack = _currentIndexInPlaylist == _playlist.length - 1;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                _pages[_selectedIndex], // Content pages
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.black.withOpacity(0.8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                        ),
                                        child: _playlist.isNotEmpty
                                            ? Image.network(
                                                _playlist[
                                                        _currentIndexInPlaylist]
                                                    .fileAlbumUrl,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    Image.network(
                                                        'https://cdn.pixabay.com/photo/2019/08/11/18/27/icon-4399630_1280.png'),
                                              )
                                            : const Icon(Icons.music_note_sharp,
                                                color: Colors.orange),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ScrollingText(
                                              text: _playlist.isNotEmpty
                                                  ? _playlist[
                                                          _currentIndexInPlaylist]
                                                      .judul
                                                  : 'Loading...',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              width: double
                                                  .infinity, // Gunakan fleksibilitas penuh
                                            ),
                                            ScrollingText(
                                              text: _playlist.isNotEmpty
                                                  ? _playlist[
                                                          _currentIndexInPlaylist]
                                                      .artis
                                                  : '',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                              width: double.infinity,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed:
                                          isFirstTrack ? null : _previousTrack,
                                      icon: Icon(
                                        Icons.skip_previous,
                                        color: isFirstTrack
                                            ? Colors.white.withOpacity(0.3)
                                            : Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: _togglePlayPause,
                                      icon: Icon(
                                        _isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed:
                                          isLastTrack ? null : _nextTrack,
                                      icon: Icon(
                                        Icons.skip_next,
                                        color: isLastTrack
                                            ? Colors.white.withOpacity(0.3)
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      BottomNavigationBar(
                        backgroundColor: Colors.transparent,
                        items: <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: Icon(
                              _selectedIndex == 0
                                  ? Icons.home
                                  : Icons.home_outlined,
                              color: _selectedIndex == 0
                                  ? Colors.orange
                                  : Colors.grey,
                              size: _selectedIndex == 0 ? 24.0 : 30.0,
                            ),
                            label: 'Home',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(
                              _selectedIndex == 1
                                  ? Icons.library_music
                                  : Icons.library_music_outlined,
                              color: _selectedIndex == 1
                                  ? Colors.orange
                                  : Colors.grey,
                              size: _selectedIndex == 1 ? 24.0 : 30.0,
                            ),
                            label: 'Library',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(
                              _selectedIndex == 2
                                  ? Icons.person
                                  : Icons.person_outline,
                              color: _selectedIndex == 2
                                  ? Colors.orange
                                  : Colors.grey,
                              size: _selectedIndex == 2 ? 24.0 : 30.0,
                            ),
                            label: 'Profile',
                          ),
                        ],
                        currentIndex: _selectedIndex,
                        selectedItemColor: Colors.orange,
                        onTap: _onItemTapped,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

extension on Object? {
  String? get fileMusicUrl => null;
}

final List<Widget> _pages = [
  const HomePage(),
  const LibraryPage(),
  const ProfilePage(),
];
