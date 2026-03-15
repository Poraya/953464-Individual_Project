import '../models/post.dart';
import '../models/highlight.dart';

class ProfileService {
  List<Post> getPosts() {
    return [
      Post(imageUrl: "assets/IMG_7735.JPG"),
      Post(imageUrl: "assets/IMG_0731.JPG"),
      Post(imageUrl: "assets/IMG_4972.JPG"),
      Post(imageUrl: "assets/IMG_6748.JPG"),
      Post(imageUrl: "assets/IMG_7754.JPG"),
      Post(imageUrl: "assets/IMG_7394.JPG"),
      Post(imageUrl: "assets/IMG_4916.JPG"),
      Post(imageUrl: "assets/IMG_3579.JPG"),
    ];
  }

  List<String> getReels() {
    return ["assets/6.MOV", "assets/7.MOV"];
  }

  List<Highlight> getHighlights() {
    return [
      Highlight(title: "I", imageUrl: "assets/IMG_7807.JPG"),
      Highlight(title: "love", imageUrl: "assets/IMG_7805.JPG"),
      Highlight(title: "Aj.", imageUrl: "assets/IMG_7804.JPG"),
      Highlight(title: "tui", imageUrl: "assets/IMG_7806.JPG"),
    ];
  }
}
