import 'package:flutter/material.dart';
import 'package:music_app/provider/playlist_provider.dart';
import 'package:provider/provider.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  void initState() {
    super.initState();
    // Ensure playlists are loaded when the widget is first displayed
    Provider.of<PlaylistProvider>(context, listen: false).fetchPlaylists();
  }

  Future<void> _showAddPlaylistDialog(BuildContext context) async {
    final namaPlaylistController = TextEditingController();
    final imgPlaylistController = TextEditingController();

    final playlistProvider =
        Provider.of<PlaylistProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Tambah Playlist'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: namaPlaylistController,
                  decoration: const InputDecoration(labelText: 'Nama Playlist'),
                ),
                TextField(
                  controller: imgPlaylistController,
                  decoration:
                      const InputDecoration(labelText: 'URL Gambar Playlist'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Ensure imgUrl is passed correctly
                final success = await playlistProvider.addPlaylist(
                  namaPlaylist: namaPlaylistController.text,
                  imgPlaylist: imgPlaylistController
                      .text, // This should be the image URL
                  imgUrl:
                      imgPlaylistController.text, // Use the same URL for imgUrl
                );

                if (mounted) {
                  Navigator.of(ctx).pop();
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Playlist berhasil ditambahkan'),
                      ),
                    );
                    // Fetch playlists again after adding
                    await playlistProvider.fetchPlaylists();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gagal menambahkan playlist'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditPlaylistDialog(
      BuildContext context, var playlist) async {
    final namaPlaylistController = TextEditingController(text: playlist.nama);
    final imgPlaylistController = TextEditingController(text: playlist.imgUrl);

    final playlistProvider =
        Provider.of<PlaylistProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Playlist'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: namaPlaylistController,
                  decoration: const InputDecoration(labelText: 'Nama Playlist'),
                ),
                TextField(
                  controller: imgPlaylistController,
                  decoration:
                      const InputDecoration(labelText: 'URL Gambar Playlist'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final success = await playlistProvider.editPlaylist(
                  id: playlist.id, // Pass the playlist ID
                  namaPlaylist:
                      namaPlaylistController.text, // Pass the new playlist name
                  imgPlaylist:
                      imgPlaylistController.text, // Pass the new image URL
                );

                if (mounted) {
                  Navigator.of(ctx).pop();
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Playlist berhasil diperbarui')),
                    );
                    playlistProvider.fetchPlaylists(); // Refresh list
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Gagal memperbarui playlist')),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, int id) async {
    final playlistProvider =
        Provider.of<PlaylistProvider>(context, listen: false);

    final confirm = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin akan menghapus playlist ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      final success = await playlistProvider.deletePlaylist(id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Playlist berhasil dihapus')),
        );
        playlistProvider.fetchPlaylists(); // Refresh list after deletion
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus playlist')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final playlistProvider = Provider.of<PlaylistProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: playlistProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : playlistProvider.playlistList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Tidak ada playlist tersedia.'),
                      ElevatedButton(
                        onPressed: () {
                          playlistProvider.fetchPlaylists();
                        },
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: playlistProvider.playlistList.length,
                  itemBuilder: (context, index) {
                    final playlist = playlistProvider.playlistList[index];
                    return GestureDetector(
                      onTap: () {
                        _showEditPlaylistDialog(context, playlist);
                      },
                      child: Card(
                        color: Colors.grey[800],
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: const Icon(Icons.queue_music_sharp,
                              size: 40, color: Colors.orange),
                          title: Text(
                            playlist.namaPlaylist,
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showEditPlaylistDialog(context, playlist);
                              } else if (value == 'delete') {
                                _confirmDelete(context, playlist.idPlaylist);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Hapus'),
                              ),
                            ],
                            icon: const Icon(Icons.more_vert,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('My Playlist', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              _showAddPlaylistDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
