import '../models/post.dart';
import '../models/highlight.dart';

class ProfileService {

  List<Post> getPosts() {
    return [
      Post(imageUrl: "https://picsum.photos/200?1"),
      Post(imageUrl: "https://picsum.photos/200?2"),
      Post(imageUrl: "https://picsum.photos/200?3"),
      Post(imageUrl: "https://picsum.photos/200?4"),
      Post(imageUrl: "https://picsum.photos/200?5"),
      Post(imageUrl: "https://picsum.photos/200?6"),
      Post(imageUrl: "https://picsum.photos/200?7"),
      Post(imageUrl: "https://picsum.photos/200?8"),
      Post(imageUrl: "https://picsum.photos/200?9"),
    ];
  }

  List<Highlight> getHighlights() {
    return [
      Highlight(title: "I", imageUrl: "https://picsum.photos/100?12"),
      Highlight(title: "love", imageUrl: "https://picsum.photos/100?13"),
      Highlight(title: "Aj.", imageUrl: "https://picsum.photos/100?14"),
      Highlight(title: "tui", imageUrl: "https://picsum.photos/100?15"),
    ];
  }
}