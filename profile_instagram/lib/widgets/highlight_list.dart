import 'package:flutter/material.dart';
import '../models/highlight.dart';

class HighlightList extends StatelessWidget {

  final List<Highlight> highlights;

  const HighlightList({super.key, required this.highlights});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: highlights.length,
        itemBuilder: (context, index) {

          var h = highlights[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(h.imageUrl),
                ),
                const SizedBox(height: 5),
                Text(h.title, style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}