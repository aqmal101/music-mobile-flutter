class Music {
  final int idMusic;
  final String judul;
  final String artis;
  final String fileMusicUrl;
  final String fileAlbumUrl;

  Music({
    required this.idMusic,
    required this.judul,
    required this.artis,
    required this.fileMusicUrl,
    required this.fileAlbumUrl,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      idMusic: json['id_music'],
      judul: json['judul'],
      artis: json['artis'],
      fileMusicUrl: json['file_music_url'],
      fileAlbumUrl: json['file_album_url'],
    );
  }
}
