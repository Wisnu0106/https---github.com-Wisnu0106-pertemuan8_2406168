import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  List photos = [];

  Future<void> getPhotos() async {
    final response = await http.get(
      Uri.parse('https://picsum.photos/v2/list?page=2&limit=10'),
    );

    if (response.statusCode == 200) {
      setState(() {
        photos = json.decode(response.body);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        title: const Text(
          "Daftar Foto",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 201, 202, 228),
        centerTitle: true,
        elevation: 0,
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // GAMBAR
                  Positioned.fill(
                    child: Image.network(
                      photos[index]['download_url'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  // OVERLAY
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // AUTHOR
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Text(
                      photos[index]['author'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // NAVIGASI BAWAH (tanpa tombol Postingan)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // karena ini halaman Foto
        selectedItemColor: const Color.fromARGB(255, 187, 107, 15),
        unselectedItemColor: const Color.fromARGB(255, 133, 121, 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: "Foto",
          ),
        ],
        onTap: (index) {
          // HOME
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyApp()),
            );
          }
          // FOTO
          else if (index == 1) {
            // sudah di halaman Foto, jadi tidak perlu pindah
          }
        },
      ),
    );
  }
}
