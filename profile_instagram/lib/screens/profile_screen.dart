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

        /// CONTENT
        Widget content = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// PROFILE HEADER
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ROW 1 : AVATAR + INFO
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage(
                            "https://picsum.photos/200",
                          ),
                        ),

                        const SizedBox(width: 20),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// USERNAME (tablet / desktop only)
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
                                    Icon(Icons.settings_outlined, size: 20),
                                  ],
                                ),

                              if (!mobile) const SizedBox(height: 8),

                              const Text(
                                "porya",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),

                              const SizedBox(height: 10),

                              const Row(
                                children: [
                                  ProfileStat(count: "9", label: "posts"),
                                  SizedBox(width: 30),
                                  ProfileStat(
                                    count: "1.7k",
                                    label: "followers",
                                  ),
                                  SizedBox(width: 30),
                                  ProfileStat(
                                    count: "1.6k",
                                    label: "following",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// ROW 2 : BIO
                    const Text("I love Mobile Apps"),

                    const SizedBox(height: 10),

                    /// ROW 3 : BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            child: const Text(
                              "Edit profile",
                              style: TextStyle(color: Color(0xFF262626)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            child: const Text(
                              "Share profile",
                              style: TextStyle(color: Color(0xFF262626)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// HIGHLIGHTS
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: HighlightList(highlights: highlights),
              ),
            ),

            const SizedBox(height: 16),

            /// TABS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.grid_on),
                SizedBox(width: 40),
                Icon(Icons.movie_creation_outlined),
                SizedBox(width: 40),
                Icon(Icons.repeat),
                SizedBox(width: 40),
                Icon(Icons.person_outline),
              ],
            ),

            const SizedBox(height: 10),

            /// POSTS GRID
            Expanded(
              child: PostGrid(posts: posts, crossAxisCount: gridCount),
            ),
          ],
        );

        /// MOBILE
        if (mobile) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {},
              ),
              title: const Text(
                "yijhin6_",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
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
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.movie_creation_outlined),
                  label: "Reels",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.send_outlined),
                  label: "Messages",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: "Search",
                ),
                BottomNavigationBarItem(
                  icon: CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage("https://picsum.photos/100"),
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
                  onEnter: (_) {
                    setState(() {
                      isHoveringRail = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      isHoveringRail = false;
                    });
                  },

                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: NavigationRail(
                      backgroundColor: Colors.white,
                      extended: isHoveringRail,

                      selectedIndex: tablet ? 6 : 8,

                      minWidth: 72,
                      minExtendedWidth: 200,

                      //  icon อยู่กลาง
                      groupAlignment: 0,

                      leading: const SizedBox(height: 18),

                      trailing: const SizedBox(height: 18),

                      destinations: tablet
                          ? const [
                              NavigationRailDestination(
                                icon: Icon(Icons.home_outlined),
                                label: Text("Home"),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.people_outline),
                                label: Text("People"),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.send_outlined),
                                label: Text("Send"),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.search),
                                label: Text("Search"),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.favorite_border),
                                label: Text("Favorite"),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.add),
                                label: Text("Post"),
                              ),
                              NavigationRailDestination(
                                icon: CircleAvatar(
                                  radius: 12,
                                  backgroundImage: NetworkImage(
                                    "https://picsum.photos/100",
                                  ),
                                ),
                                label: Text("Profile"),
                              ),
                            ]
                          : const [
                              NavigationRailDestination(
                                icon: Icon(Icons.home_outlined),
                                selectedIcon: Icon(Icons.home),
                                label: Text("Home"),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.movie_filter_outlined),
                                label: Text("Reels"),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.send_outlined),
                                label: Text("Messages"),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.search),
                                label: Text("Search"),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.explore_outlined),
                                label: Text("Explore"),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.favorite_border),
                                label: Text("Notifications"),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.add),
                                label: Text("Post"),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.bar_chart_outlined),
                                label: Text("Dashboard"),
                              ),
                              NavigationRailDestination(
                                icon: CircleAvatar(
                                  radius: 12,
                                  backgroundImage: NetworkImage(
                                    "https://picsum.photos/100",
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
