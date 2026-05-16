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

        backgroundColor: Colors.green,
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
                            Colors.black.withOpacity(0.7),
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

      // NAVIGASI BAWAH
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: "Postingan",
          ),

          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

          BottomNavigationBarItem(icon: Icon(Icons.image), label: "Foto"),
        ],

        onTap: (index) {
          // POSTINGAN
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PostPage()),
            );
          }
          // HOME
          else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyApp()),
            );
          }
        },
      ),
    );
  }
}
