import 'package:flutter/material.dart';
import '../models/post.dart';

class PostGrid extends StatelessWidget {

  final List<Post> posts;
  final int crossAxisCount;

  const PostGrid({
    super.key,
    required this.posts,
    required this.crossAxisCount,
  });

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
      itemCount: posts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        return Image.network(
          posts[index].imageUrl,
          fit: BoxFit.cover,
        );
      },
    );
  }
}