import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/highlight.dart';
import '../services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {

  final ProfileService _service = ProfileService();

  List<Post> posts = [];
  List<Highlight> highlights = [];

  void loadData() {
    posts = _service.getPosts();
    highlights = _service.getHighlights();
    notifyListeners();
  }

  /// GRID RESPONSIVE
  int getGridCount(double width) {
    if (width < 600) return 3;      // mobile
    if (width < 1024) return 4;     // tablet
    return 5;                       // desktop
  }

  /// DEVICE TYPE
  bool isMobile(double width) => width < 600;

  bool isTablet(double width) =>
      width >= 600 && width < 1024;

  bool isDesktop(double width) =>
      width >= 1024;
}