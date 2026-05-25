import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/photo_provider.dart';
import '../main.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted) {
        context.read<PhotoProvider>().getPhotos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<PhotoProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        title: const Text(
          "Daftar Foto",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 201, 202, 228),
        centerTitle: true,
      ),

      body: provider.isLoading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : provider.errorMessage.isNotEmpty

              ? Center(
                  child: Text(provider.errorMessage),
                )

              : GridView.builder(

                  padding: const EdgeInsets.all(12),

                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),

                  itemCount: provider.photos.length,

                  itemBuilder: (context, index) {

                    final photo = provider.photos[index];

                    return Card(

                      elevation: 8,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: ClipRRect(

                        borderRadius: BorderRadius.circular(20),

                        child: Stack(
                          children: [

                            Positioned.fill(
                              child: Image.network(
                                photo['download_url'],
                                fit: BoxFit.cover,
                              ),
                            ),

                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.7),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Positioned(
                              left: 10,
                              bottom: 10,
                              child: Text(
                                photo['author'],
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

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,

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
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MyApp(),
              ),
            );
          }
        },
      ),
    );
  }
}