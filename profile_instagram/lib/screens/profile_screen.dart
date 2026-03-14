import 'package:flutter/material.dart';
import '../services/profile_service.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_stat.dart';
import '../widgets/highlight_list.dart';
import '../widgets/post_grid.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isHoveringRail = false;

  @override
  Widget build(BuildContext context) {
    final service = ProfileService();
    final provider = ProfileProvider();

    final posts = service.getPosts();
    final highlights = service.getHighlights();

    return LayoutBuilder(
      builder: (context, constraints) {
        int gridCount = provider.getGridCount(constraints.maxWidth);

        bool mobile = provider.isMobile(constraints.maxWidth);
        bool tablet = provider.isTablet(constraints.maxWidth);
        bool desktop = provider.isDesktop(constraints.maxWidth);

        // คำนวณความสูง grid จากจำนวน post และ column
        double itemSize = constraints.maxWidth / gridCount;
        int rowCount = (posts.length / gridCount).ceil();
        double gridHeight = rowCount * itemSize;

        /// CONTENT — CustomScrollView scroll ทั้งหน้า
        Widget content = CustomScrollView(
          slivers: [
            /// PROFILE HEADER
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ROW 1 : AVATAR + INFO
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                child: const CircleAvatar(
                                  radius: 42,
                                  backgroundImage: AssetImage("assets/profile.JPG"),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF0095F6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 20),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!mobile)
                                Row(
                                  children: const [
                                    Text(
                                      "yijhin6_",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Icon(Icons.settings_outlined, size: 20),
                                    ),
                                  ],
                                ),

                              if (!mobile) const SizedBox(height: 8),

                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: "porya ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "she/her",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 10),

                              const Row(
                                children: [
                                  ProfileStat(count: "19", label: "posts"),
                                  SizedBox(width: 30),
                                  ProfileStat(count: "1.7k", label: "followers"),
                                  SizedBox(width: 30),
                                  ProfileStat(count: "1.6k", label: "following"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// BIO
                    const Text(
                      "I love Mobile App ",
                      style: TextStyle(fontSize: 14),
                    ),

                    const SizedBox(height: 4),

                    /// Professional dashboard
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: const [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Professional dashboard",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.trending_up,
                                        color: Colors.green,
                                        size: 14,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "21.9K views in the last 30 days.",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, color: Colors.black54),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEFEFEF),
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "Edit profile",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEFEFEF),
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "Share profile",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /// HIGHLIGHTS
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: HighlightList(highlights: highlights),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            /// TAB ICONS
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Icon(Icons.grid_on, size: 24),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Icon(Icons.smart_display_outlined, size: 24),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Icon(Icons.repeat_rounded, size: 24),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Icon(Icons.person_outline, size: 24),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 10)),

            /// POSTS GRID
            /// ใส่ใน SizedBox ที่มีความสูงแน่นอน เพื่อให้ PostGrid render ได้ใน Sliver
            SliverToBoxAdapter(
              child: SizedBox(
                height: gridHeight,
                child: PostGrid(posts: posts, crossAxisCount: gridCount),
              ),
            ),
          ],
        );

        /// MOBILE
        if (mobile) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.add, color: Colors.black),
                onPressed: () {},
                mouseCursor: SystemMouseCursors.click,
              ),
              title: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "yijhin6_",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.black),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.apps_outlined, color: Colors.black),
                  onPressed: () {},
                  mouseCursor: SystemMouseCursors.click,
                ),
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed: () {},
                  mouseCursor: SystemMouseCursors.click,
                ),
              ],
            ),
            backgroundColor: Colors.white,
            body: content,
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              currentIndex: 4,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              mouseCursor: SystemMouseCursors.click,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  activeIcon: Icon(Icons.home_filled),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.smart_display_outlined),
                  activeIcon: Icon(Icons.smart_display_outlined),
                  label: "Reels",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.near_me_outlined),
                  activeIcon: Icon(Icons.near_me_rounded),
                  label: "Messages",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: "Search",
                ),
                BottomNavigationBarItem(
                  icon: CircleAvatar(
                    radius: 12,
                    backgroundImage: AssetImage("assets/profile.JPG"),
                  ),
                  label: "",
                ),
              ],
            ),
          );
        }

        /// TABLET + DESKTOP
        if (tablet || desktop) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Row(
              children: [
                MouseRegion(
                  onEnter: (_) => setState(() => isHoveringRail = true),
                  onExit: (_) => setState(() => isHoveringRail = false),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: NavigationRail(
                      backgroundColor: Colors.white,
                      extended: isHoveringRail,
                      selectedIndex: tablet ? 6 : 8,
                      minWidth: 72,
                      minExtendedWidth: 200,
                      groupAlignment: 0,
                      leading: const SizedBox(height: 18),
                      trailing: const SizedBox(height: 18),
                      destinations: tablet
                          ? const [
                              NavigationRailDestination(
                                icon: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Icon(Icons.home_filled),
                                ),
                                selectedIcon: Icon(Icons.home_filled),
                                label: Text("Home"),
                              ),
                              NavigationRailDestination(
                                icon: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Icon(Icons.people_outline_rounded),
                                ),
                                label: Text("Friends"),
                              ),
                              NavigationRailDestination(
                                icon: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Icon(Icons.near_me_outlined),
                                ),
                                selectedIcon: Icon(Icons.near_me_rounded),
                                label: Text("Messages"),
                              ),
                              NavigationRailDestination(
                                icon: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Icon(Icons.search),
                                ),
                                selectedIcon: Icon(Icons.search),
                                label: Text("Search"),
                              ),
                              NavigationRailDestination(
                                icon: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Icon(Icons.favorite_border),
                                ),
                                selectedIcon: Icon(Icons.favorite),
                                label: Text("Notifications"),
                              ),
                              NavigationRailDestination(
                                icon: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Icon(Icons.add),
                                ),
                                label: Text("Post"),
                              ),
                              NavigationRailDestination(
                                icon: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundImage: AssetImage("assets/profile.JPG"),
                                  ),
                                ),
                                label: Text("Profile"),
                              ),
                            ]
                          : const [
                              NavigationRailDestination(
                                icon: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Icon(Icons.home_filled),
                                ),
                                selectedIcon: Icon(Icons.home_filled),
                                label: Text("Home"),
                              ),
                              NavigationRailDestination(
                                icon: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Icon(Icons.smart_display_outlined),
                                ),
                                label: Text("Reels"),
                              ),
                              NavigationRailDestination(
                                icon: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Icon(Icons.near_me_outlined),
                                ),
                                selectedIcon: Icon(Icons.near_me_rounded),
                                label: Text("Messages"),
                              ),
                              NavigationRailDestination(
                                icon: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Icon(Icons.search),
                                ),
                                selectedIcon: Icon(Icons.search),
                                label: Text("Search"),
                              ),
                              NavigationRailDestination(
                                icon: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Icon(Icons.explore_outlined),
                                ),
                                selectedIcon: Icon(Icons.explore),
                                label: Text("Explore"),
                              ),
                              NavigationRailDestination(
                                icon: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Icon(Icons.favorite_border),
                                ),
                                selectedIcon: Icon(Icons.favorite),
                                label: Text("Notifications"),
                              ),
                              NavigationRailDestination(
                                icon: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Icon(Icons.add),
                                ),
                                label: Text("Post"),
                              ),
                              NavigationRailDestination(
                                icon: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Icon(Icons.insert_chart_outlined_rounded),
                                ),
                                label: Text("Dashboard"),
                              ),
                              NavigationRailDestination(
                                icon: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundImage: AssetImage("assets/profile.JPG"),
                                  ),
                                ),
                                label: Text("Profile"),
                              ),
                            ],
                    ),
                  ),
                ),

                Expanded(
                  child: Center(
                    child: Container(
                      width: 935,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                      ),
                      child: content,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}