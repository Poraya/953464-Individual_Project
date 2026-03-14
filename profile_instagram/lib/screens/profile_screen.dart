import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../services/profile_service.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_stat.dart';
import '../widgets/highlight_list.dart';
import '../widgets/post_grid.dart';

// ─────────────────────────────────────────────
// Tab icon (grid/reels/collab/tagged)
// ─────────────────────────────────────────────
class _TabIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TabIcon({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.transparent,
            child: Icon(
              icon,
              size: 24,
              color: selected ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Widget สำหรับ Navigation Rail item แบบ IG
// hover → แสดง label ลอยออกมาทางขวา
// ─────────────────────────────────────────────
class _RailItem extends StatefulWidget {
  final Widget icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _RailItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  State<_RailItem> createState() => _RailItemState();
}

class _RailItemState extends State<_RailItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _hovering
                ? Colors.grey.shade200
                : (widget.selected ? Colors.grey.shade100 : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.icon,
              // label ลอยออกมาเมื่อ hover
              AnimatedSize(
                duration: const Duration(milliseconds: 150),
                child: _hovering
                    ? Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: Text(
                          widget.label,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ProfileScreen
// ─────────────────────────────────────────────
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0; // 0=posts, 1=reels, 2=collab, 3=tagged

  @override
  Widget build(BuildContext context) {
    final service = ProfileService();
    final provider = ProfileProvider();

    final posts = service.getPosts();
    final reels = service.getReels(); // List<String> path วิดีโอ
    final highlights = service.getHighlights();

    return LayoutBuilder(
      builder: (context, constraints) {
        int gridCount = provider.getGridCount(constraints.maxWidth);

        bool mobile = provider.isMobile(constraints.maxWidth);
        bool tablet = provider.isTablet(constraints.maxWidth);
        bool desktop = provider.isDesktop(constraints.maxWidth);

        // tab reels (index 1) ใช้ 2 คอลัมน์, อื่น ๆ ใช้ gridCount ปกติ
        // tab Reels → 2 คอลัมน์ + ใช้ reels data
        final activeItems = posts; // reels ใช้ path string แยก
        int activeGridCount = _selectedTab == 1 ? 2 : gridCount;
        double itemSize = constraints.maxWidth / activeGridCount;
        int rowCount = _selectedTab == 1
            ? (reels.length / activeGridCount).ceil()
            : (activeItems.length / activeGridCount).ceil();
        double gridHeight = rowCount * itemSize;

        // ─────────────────────────────────────────────
        // CONTENT — scroll ทั้งหน้า
        // ─────────────────────────────────────────────
        Widget content = CustomScrollView(
          slivers: [
            /// PROFILE HEADER
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Avatar ──
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
                                  // ── เปลี่ยน path ตรงนี้ถ้าชื่อไฟล์ต่างออกไป ──
                                  backgroundImage:
                                      AssetImage("assets/profile.JPG"),
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
                                  child: const Icon(Icons.add,
                                      color: Colors.white, size: 16),
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
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(width: 10),
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Icon(Icons.settings_outlined,
                                          size: 20),
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
                                          fontSize: 14),
                                    ),
                                    TextSpan(
                                      text: "she/her",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Row(
                                children: [
                                  ProfileStat(count: "19", label: "posts"),
                                  SizedBox(width: 30),
                                  ProfileStat(count: "17k", label: "followers"),
                                  SizedBox(width: 30),
                                  ProfileStat(
                                      count: "1k", label: "following"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    const Text("I love Mobile App ",
                        style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),

                    // Professional dashboard
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
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
                                  Text("Professional dashboard",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13)),
                                  SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Icon(Icons.trending_up,
                                          color: Colors.green, size: 14),
                                      SizedBox(width: 4),
                                      Text("21.9K views in the last 30 days.",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12)),
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

                    // Buttons
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
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text("Edit profile",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13)),
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
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text("Share profile",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Highlights
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: HighlightList(highlights: highlights),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Tab icons
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _TabIcon(
                        icon: Icons.grid_on,
                        selected: _selectedTab == 0,
                        onTap: () => setState(() => _selectedTab = 0),
                      ),
                      _TabIcon(
                        icon: Icons.smart_display_outlined,
                        selected: _selectedTab == 1,
                        onTap: () => setState(() => _selectedTab = 1),
                      ),
                      _TabIcon(
                        icon: Icons.repeat_rounded,
                        selected: _selectedTab == 2,
                        onTap: () => setState(() => _selectedTab = 2),
                      ),
                      _TabIcon(
                        icon: Icons.person_outline,
                        selected: _selectedTab == 3,
                        onTap: () => setState(() => _selectedTab = 3),
                      ),
                    ],
                  ),
                  // indicator bar ใต้ tab ที่เลือก
                  Row(
                    children: List.generate(4, (i) => Expanded(
                      child: Container(
                        height: 1,
                        color: _selectedTab == i ? Colors.black : Colors.grey.shade200,
                      ),
                    )),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 2)),

            // Posts grid / Reels grid
            SliverToBoxAdapter(
              child: SizedBox(
                height: gridHeight,
                child: _selectedTab == 1
                    // ── Reels tab: GridView 2 คอลัมน์ ใช้ video_player ──
                    ? GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: activeGridCount,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          childAspectRatio: 9 / 16,
                        ),
                        itemCount: reels.length,
                        itemBuilder: (context, index) {
                          return _ReelItem(assetPath: reels[index]);
                        },
                      )
                    // ── Posts/Collab/Tagged tab: PostGrid เดิม ──
                    : PostGrid(posts: activeItems, crossAxisCount: activeGridCount),
              ),
            ),
          ],
        );

   
        // MOBILE
      
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
                    Text("yijhin6_",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black)),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down,
                        size: 20, color: Colors.black),
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
                    icon: Icon(Icons.home_filled), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.smart_display_outlined), label: "Reels"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.near_me_outlined), label: "Messages"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: "Search"),
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

        // ─────────────────────────────────────────────
        // TABLET + DESKTOP — custom rail ด้วย _RailItem
        // ─────────────────────────────────────────────
        if (tablet || desktop) {
          final tabletItems = <Map<String, dynamic>>[
            {'icon': const Icon(Icons.home_filled, size: 26), 'label': 'Home'},
            {'icon': const Icon(Icons.people_outline_rounded, size: 26), 'label': 'Friends'},
            {'icon': const Icon(Icons.near_me_outlined, size: 26), 'label': 'Messages'},
            {'icon': const Icon(Icons.search, size: 26), 'label': 'Search'},
            {'icon': const Icon(Icons.favorite_border, size: 26), 'label': 'Notification'},
            {'icon': const Icon(Icons.add, size: 26), 'label': 'Post'},
            {
              'icon': const CircleAvatar(
                radius: 13,
                backgroundImage: AssetImage("assets/profile.JPG"),
              ),
              'label': 'Profile'
            },
          ];

          final desktopItems = <Map<String, dynamic>>[
            {'icon': const Icon(Icons.home_filled, size: 26), 'label': 'Home'},
            {'icon': const Icon(Icons.smart_display_outlined, size: 26), 'label': 'Reels'},
            {'icon': const Icon(Icons.near_me_outlined, size: 26), 'label': 'Messages'},
            {'icon': const Icon(Icons.search, size: 26), 'label': 'Search'},
            {'icon': const Icon(Icons.explore_outlined, size: 26), 'label': 'Explore'},
            {'icon': const Icon(Icons.favorite_border, size: 26), 'label': 'Notification'},
            {'icon': const Icon(Icons.add, size: 26), 'label': 'Post'},
            {'icon': const Icon(Icons.insert_chart_outlined_rounded, size: 26), 'label': 'Dashboard'},
            {
              'icon': const CircleAvatar(
                radius: 13,
                backgroundImage: AssetImage("assets/profile.JPG"),
              ),
              'label': 'Profile'
            },
          ];

          final items = tablet ? tabletItems : desktopItems;
          final selectedIndex = tablet ? 6 : 8; // โปรไฟล์

          return Scaffold(
            backgroundColor: Colors.white,
            body: Row(
              children: [
                // ── Custom Rail ──
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo placeholder
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Icon(Icons.camera_alt_outlined, size: 28),
                      ),
                      const SizedBox(height: 8),
                      // Items
                      ...items.asMap().entries.map((entry) {
                        final i = entry.key;
                        final item = entry.value;
                        return _RailItem(
                          icon: item['icon'] as Widget,
                          label: item['label'] as String,
                          selected: i == selectedIndex,
                          onTap: () {},
                        );
                      }),
                    ],
                  ),
                ),

                // ── Main content ──
                Expanded(
                  child: Center(
                    child: Container(
                      width: 935,
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 20),
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

// ─────────────────────────────────────────────
// Reel item — เล่นวิดีโอจาก asset ด้วย video_player
// กดเพื่อ play/pause, แสดง play icon ตอน pause
// ─────────────────────────────────────────────
class _ReelItem extends StatefulWidget {
  final String assetPath;
  const _ReelItem({required this.assetPath});

  @override
  State<_ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<_ReelItem> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.assetPath)
      ..initialize().then((_) {
        if (mounted) setState(() => _initialized = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlay,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // พื้นหลังดำขณะโหลด
            Container(color: Colors.black),

            if (_initialized)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),

            // loading indicator
            if (!_initialized)
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),

            // play icon overlay ตอน pause
            if (_initialized && !_controller.value.isPlaying)
              Positioned(
                top: 8,
                left: 8,
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 28,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                ),
              ),
          ],
        ),
      ),
    );
  }
}