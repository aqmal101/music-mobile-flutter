class Playlist {
  final int idPlaylist;
  final String namaPlaylist;
  final String imgPlaylist;

  Playlist({
    required this.idPlaylist,
    required this.namaPlaylist,
    required this.imgPlaylist,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      idPlaylist: json['id_playlist'] ?? '',
      namaPlaylist: json['nama_playlist'] ?? '',
      imgPlaylist: json['img_playlist'] ?? '',
    );
  }
}
