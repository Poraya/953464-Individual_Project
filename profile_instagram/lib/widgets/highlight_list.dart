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

        itemCount: highlights.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(
                          BorderSide(color: Color(0xFFDBDBDB), width: 1),
                        ),
                      ),
                      child: Icon(Icons.add, size: 28, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "New",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ],
              ),
            );
          }

          final h = highlights[index - 1];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () {},
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFDBDBDB),
                        width: 1,
                      ),
                    ),

                    padding: const EdgeInsets.all(2),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(h.imageUrl),
                    ),
                  ),
                  const SizedBox(height: 6),

                  SizedBox(
                    width: 64,
                    child: Text(
                      h.title,
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
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
