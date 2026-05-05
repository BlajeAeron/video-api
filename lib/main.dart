import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List videos = [];
  bool isLoading = true;
  String errorMessage = "";

  final titleController = TextEditingController();
  final thumbnailController = TextEditingController();
  final videoController = TextEditingController();
  final String baseUrl =
      "https://video-api-production-0dfb.up.railway.app/get_videos.php";

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/get_videos.php"));

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          videos = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Server error: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      print("ERROR: $e");
      setState(() {
        errorMessage = "Gagal koneksi ke server";
        isLoading = false;
      });
    }
  }

  Future<void> addVideo() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/add_video.php"),
        body: {
          'title': titleController.text,
          'thumbnail': thumbnailController.text,
          'video_url': videoController.text,
        },
      );

      print("ADD STATUS: ${response.statusCode}");
      print("ADD BODY: ${response.body}");

      if (response.statusCode == 200) {
        titleController.clear();
        thumbnailController.clear();
        videoController.clear();
        fetchVideos();
      }
    } catch (e) {
      print("ADD ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Database")),
      body: Column(
        children: [
          // 🔹 FORM
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: thumbnailController,
                  decoration: const InputDecoration(labelText: "Thumbnail URL"),
                ),
                TextField(
                  controller: videoController,
                  decoration: const InputDecoration(labelText: "Video URL"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: addVideo,
                  child: const Text("Simpan"),
                ),
              ],
            ),
          ),

          const Divider(),

          // 🔹 LIST
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : videos.isEmpty
                ? const Center(child: Text("Data kosong"))
                : ListView.builder(
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      var video = videos[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  VideoPlayerPage(videoUrl: video['video_url']),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Image.network(
                                video['thumbnail'],
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    color: Colors.grey,
                                    child: const Center(
                                      child: Icon(Icons.broken_image),
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(video['title']),
                              ),
                            ],
                          ),
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

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerPage({super.key, required this.videoUrl});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController controller;
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          isReady = true;
        });
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Play Video")),
      body: Center(
        child: isReady
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        controller.value.isPlaying
                            ? controller.pause()
                            : controller.play();
                      });
                    },
                    child: Text(controller.value.isPlaying ? "Pause" : "Play"),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
