import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayer extends StatefulWidget {
  final String audioUrl;

  const MusicPlayer({super.key, required this.audioUrl});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Load the audio and listen for updates
    _audioPlayer.setUrl(widget.audioUrl).then((_) {
      setState(() {
        _totalDuration = _audioPlayer.duration ?? Duration.zero;
      });
    });

    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
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

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        // borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Now Playing",
                style: TextStyle(color: Colors.white),
              ),
              IconButton(
                onPressed: _togglePlayPause,
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          // Progress bar
          Slider(
            value: _currentPosition.inSeconds.toDouble(),
            max: _totalDuration.inSeconds.toDouble(),
            min: 0.0,
            onChanged: (value) {
              _audioPlayer.seek(Duration(seconds: value.toInt()));
            },
          ),
          // Progress text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_currentPosition),
                style: const TextStyle(color: Colors.white, fontSize: 12.0),
              ),
              Text(
                _formatDuration(_totalDuration),
                style: const TextStyle(color: Colors.white, fontSize: 12.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Format duration as mm:ss
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
