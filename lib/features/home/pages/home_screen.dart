import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vibra/features/home/livestream.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Streams'),
      ),
      body: ListView.builder(
        itemCount: mockStreams.length,
        itemBuilder: (context, index) {
          final stream = mockStreams[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(stream.thumbnailUrl),
                  const SizedBox(height: 8.0),
                  Text(stream.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      CircleAvatar(
                        child: SvgPicture.asset(stream.streamerAvatar),
                      ),
                      const SizedBox(width: 8.0),
                      Text(stream.streamerName),
                      const Spacer(),
                      const Icon(Icons.visibility),
                      const SizedBox(width: 4.0),
                      Text(stream.viewerCount.toString()),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
