import 'package:flutter/material.dart';
import 'models/post_model.dart';
import 'service/post_service.dart';
import 'pages/photo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pertemuan 8 - Consume API',
      home: PostPage(),
    );
  }
}

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  late Future<List<PostModel>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = PostService.getPosts();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Postingan'),
        backgroundColor: Colors.blueAccent,
      ),

      body: FutureBuilder<List<PostModel>>(
        future: futurePosts,

        builder: (context, snapshot) {

          if (snapshot.hasData) {

            final posts = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: posts.length,

              itemBuilder: (context, index) {

                final post = posts[index];

                return Card(
                  elevation: 5,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),

                  margin: const EdgeInsets.only(bottom: 15),

                  child: Padding(
                    padding: const EdgeInsets.all(15),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Text(
                          post.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          post.body,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );

          } else if (snapshot.hasError) {

            return Center(
              child: Text('Error: ${snapshot.error}'),
            );

          } else {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),

      // NAVIGASI BAWAH
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: "Postingan",
          ),

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
          if (index == 1) {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MyApp(),
              ),
            );
          }

          // FOTO
          else if (index == 2) {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PhotoPage(),
              ),
            );
          }
        },
      ),
    );
  }
}