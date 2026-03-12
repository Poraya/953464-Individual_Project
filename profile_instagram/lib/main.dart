import 'package:flutter/material.dart';

void main() {
  runApp(const InstagramProfileApp());
}

class InstagramProfileApp extends StatelessWidget {
  const InstagramProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Instagram Profile",
      theme: ThemeData(primarySwatch: Colors.grey),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final List<String> posts = const [
    "https://picsum.photos/200?1",
    "https://picsum.photos/200?2",
    "https://picsum.photos/200?3",
    "https://picsum.photos/200?4",
    "https://picsum.photos/200?5",
    "https://picsum.photos/200?6",
    "https://picsum.photos/200?7",
    "https://picsum.photos/200?8",
    "https://picsum.photos/200?9",
  ];
  final List<Map<String, String>> highlights = const [
    {"title": "New", "image": ""},
    {"title": "I", "image": "https://picsum.photos/100?11"},
    {"title": "love", "image": "https://picsum.photos/100?12"},
    {"title": "Aj.", "image": "https://picsum.photos/100?13"},
    {"title": "tui", "image": "https://picsum.photos/100?14"},
  ];

  int getGridCount(double width) {
    if (width < 600) return 3;
    if (width < 1024) return 4;
    return 6;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = getGridCount(constraints.maxWidth);
        bool isMobile = constraints.maxWidth < 600;

        Widget profileContent = SafeArea(
          child: Column(
            children: [
              // PROFILE HEADER
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        "https://picsum.photos/200",
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          ProfileStat(count: "120", label: "Posts"),
                          ProfileStat(count: "1.2K", label: "Followers"),
                          ProfileStat(count: "300", label: "Following"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "porya",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("se cmu"),
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text("Edit Profile"),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: highlights.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              highlights[index]["image"]!,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            highlights[index]["title"]!,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(Icons.grid_on),
                  Icon(Icons.movie_creation_outlined),
                  Icon(Icons.repeat),
                  Icon(Icons.person_outline),
                ],
              ),

              Expanded(
                child: GridView.builder(
                  itemCount: posts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemBuilder: (context, index) {
                    return Image.network(posts[index], fit: BoxFit.cover);
                  },
                ),
              ),
            ],
          ),
        );

        // MOBILE
        if (isMobile) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "praii",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: const [
                Icon(Icons.add_box_outlined),
                SizedBox(width: 10),
                Icon(Icons.menu),
                SizedBox(width: 10),
              ],
            ),
            body: profileContent,
            bottomNavigationBar: BottomNavigationBar(
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

        // TABLET / DESKTOP
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: 4,
                labelType: NavigationRailLabelType.all,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text("Home"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.search),
                    label: Text("Search"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.movie_creation_outlined),
                    label: Text("Reels"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite_border),
                    label: Text("Activity"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person),
                    label: Text("Profile"),
                  ),
                ],
              ),
              Expanded(
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text("praii"),
                    actions: const [
                      Icon(Icons.add_box_outlined),
                      SizedBox(width: 10),
                      Icon(Icons.menu),
                      SizedBox(width: 10),
                    ],
                  ),
                  body: profileContent,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProfileStat extends StatelessWidget {
  final String count;
  final String label;

  const ProfileStat({super.key, required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label),
      ],
    );
  }
}
