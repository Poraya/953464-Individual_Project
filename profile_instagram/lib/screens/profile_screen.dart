import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import '../models/highlight.dart';
import '../models/post.dart';
import '../providers/profile_provider.dart';
import '../services/profile_service.dart';
import '../widgets/highlight_list.dart';
import '../widgets/post_grid.dart';
import '../widgets/profile_stat.dart';

const _kProfileImage = AssetImage('assets/profile.JPG');

class _TabIcon extends StatelessWidget {
  const _TabIcon({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
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

class _RailItem extends StatelessWidget {
  const _RailItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.showLabel = false,
    this.isHovered = false,
    this.onTap,
    this.onEnter,
    this.onExit,
  });

  final Widget icon;
  final String label;
  final bool selected;
  final bool showLabel;
  final bool isHovered;
  final VoidCallback? onTap;
  final VoidCallback? onEnter;
  final VoidCallback? onExit;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onEnter?.call(),
      onExit: (_) => onExit?.call(),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isHovered
                ? Colors.grey.shade200
                : selected
                ? Colors.grey.shade100
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              AnimatedSize(
                duration: const Duration(milliseconds: 150),
                child: showLabel
                    ? Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
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

//Reels
class _ReelItem extends StatefulWidget {
  const _ReelItem({required this.assetPath});

  final String assetPath;

  @override
  State<_ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<_ReelItem> {
  late final VideoPlayerController _controller;
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _togglePlay,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: Colors.black),
            if (_initialized)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            if (_initialized && !_controller.value.isPlaying)
              const Positioned(
                top: 8,
                left: 8,
                child: Icon(
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

// ProfileScreen
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0;
  bool _isRailHovered = false;
  int _hoveredRailIndex = -1;

  // Navigation rail items

  static const _profileAvatar = CircleAvatar(
    radius: 13,
    backgroundImage: _kProfileImage,
  );

  List<Map<String, dynamic>> get _tabletItems => [
    {'icon': const Icon(Icons.home_filled, size: 26), 'label': 'Home'},
    {
      'icon': const Icon(Icons.smart_display_outlined, size: 26),
      'label': 'Reels',
    },
    {
      'icon': const Icon(Icons.people_outline_rounded, size: 26),
      'label': 'Friends',
    },
    {'icon': const Icon(Icons.near_me_outlined, size: 26), 'label': 'Messages'},
    {'icon': const Icon(Icons.search, size: 26), 'label': 'Search'},
    {
      'icon': const Icon(Icons.favorite_border, size: 26),
      'label': 'Notifications',
    },
    {'icon': const Icon(Icons.add, size: 26), 'label': 'Create'},
    {'icon': _profileAvatar, 'label': 'Profile'},
  ];

  List<Map<String, dynamic>> get _desktopItems => [
    {'icon': const Icon(Icons.home_filled, size: 26), 'label': 'Home'},
    {
      'icon': const Icon(Icons.smart_display_outlined, size: 26),
      'label': 'Reels',
    },
    {'icon': const Icon(Icons.near_me_outlined, size: 26), 'label': 'Messages'},
    {'icon': const Icon(Icons.search, size: 26), 'label': 'Search'},
    {'icon': const Icon(Icons.explore_outlined, size: 26), 'label': 'Explore'},
    {
      'icon': const Icon(Icons.favorite_border, size: 26),
      'label': 'Notifications',
    },
    {'icon': const Icon(Icons.add, size: 26), 'label': 'Create'},
    {
      'icon': const Icon(Icons.insert_chart_outlined_rounded, size: 26),
      'label': 'Dashboard',
    },
    {'icon': _profileAvatar, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    final service = ProfileService();
    final provider = ProfileProvider();
    final posts = service.getPosts();
    final reels = service.getReels();
    final highlights = service.getHighlights();

    return LayoutBuilder(
      builder: (context, constraints) {
        final gridCount = provider.getGridCount(constraints.maxWidth);
        final isMobile = provider.isMobile(constraints.maxWidth);
        final isTablet = provider.isTablet(constraints.maxWidth);
        final isDesktop = provider.isDesktop(constraints.maxWidth);

        final isReelsTab = _selectedTab == 1;
        final activeGridCount = isReelsTab ? 2 : gridCount;
        final activeCount = isReelsTab ? reels.length : posts.length;
        final itemSize = constraints.maxWidth / activeGridCount;
        final gridHeight = (activeCount / activeGridCount).ceil() * itemSize;

        final content = _buildContent(
          posts: posts,
          reels: reels,
          highlights: highlights,
          gridHeight: gridHeight,
          activeGridCount: activeGridCount,
          isReelsTab: isReelsTab,
        );

        if (isMobile) return _buildMobile(content);
        if (isTablet || isDesktop)
          return _buildTabletDesktop(content, isTablet);
        return const SizedBox.shrink();
      },
    );
  }

  // Content

  Widget _buildContent({
    required List<Post> posts,
    required List<String> reels,
    required List<Highlight> highlights,
    required double gridHeight,
    required int activeGridCount,
    required bool isReelsTab,
  }) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader()),
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: HighlightList(highlights: highlights),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(child: _buildTabBar()),
        const SliverToBoxAdapter(child: SizedBox(height: 2)),
        SliverToBoxAdapter(
          child: SizedBox(
            height: gridHeight,
            child: isReelsTab
                ? _buildReelsGrid(reels, activeGridCount)
                : PostGrid(posts: posts, crossAxisCount: activeGridCount),
          ),
        ),
      ],
    );
  }

  // Profile header

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = ProfileProvider().isMobile(constraints.maxWidth);
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatarRow(isMobile),
              const SizedBox(height: 12),
              const Text('I love Mobile App', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 4),
              _buildDashboardCard(),
              const SizedBox(height: 10),
              _buildActionButtons(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatarRow(bool isMobile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAvatar(),
        const SizedBox(width: 20),
        Expanded(child: _buildUserInfo(isMobile)),
      ],
    );
  }

  Widget _buildAvatar() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
            ),
            child: const CircleAvatar(
              radius: 42,
              backgroundImage: _kProfileImage,
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
              child: const Icon(Icons.add, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMobile) ...[
          Row(
            children: const [
              Text(
                'yijhin6_',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 10),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Icon(Icons.settings_outlined, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        RichText(
          text: const TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: 'porya ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              TextSpan(
                text: 'she/her',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Row(
          children: [
            ProfileStat(count: '19', label: 'posts'),
            SizedBox(width: 30),
            ProfileStat(count: '17k', label: 'followers'),
            SizedBox(width: 30),
            ProfileStat(count: '1k', label: 'following'),
          ],
        ),
      ],
    );
  }

  Widget _buildDashboardCard() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                    'Professional dashboard',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.trending_up, color: Colors.green, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '21.9K views in the last 30 days.',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
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
    );
  }

  Widget _buildActionButtons() {
    final style = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFEFEFEF),
      foregroundColor: Colors.black,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
    return Row(
      children: [
        Expanded(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ElevatedButton(
              onPressed: () {},
              style: style,
              child: const Text(
                'Edit profile',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
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
              style: style,
              child: const Text(
                'Share profile',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Tab bar
  Widget _buildTabBar() {
    const tabs = [
      Icons.grid_on,
      Icons.smart_display_outlined,
      Icons.repeat_rounded,
      Icons.person_outline,
    ];
    return Column(
      children: [
        Row(
          children: List.generate(
            tabs.length,
            (i) => _TabIcon(
              icon: tabs[i],
              selected: _selectedTab == i,
              onTap: () => setState(() => _selectedTab = i),
            ),
          ),
        ),
        Row(
          children: List.generate(
            tabs.length,
            (i) => Expanded(
              child: Container(
                height: 1,
                color: _selectedTab == i ? Colors.black : Colors.grey.shade200,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Reels grid
  Widget _buildReelsGrid(List<String> reels, int crossAxisCount) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 9 / 16,
      ),
      itemCount: reels.length,
      itemBuilder: (_, i) => _ReelItem(assetPath: reels[i]),
    );
  }

  // Mobile
  Widget _buildMobile(Widget content) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                'yijhin6_',
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
      body: content,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: 4,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        mouseCursor: SystemMouseCursors.click,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_display_outlined),
            label: 'Reels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.near_me_outlined),
            label: 'Messages',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: CircleAvatar(radius: 12, backgroundImage: _kProfileImage),
            label: '',
          ),
        ],
      ),
    );
  }

  // Tablet / Desktop

  Widget _buildTabletDesktop(Widget content, bool isTablet) {
    final items = isTablet ? _tabletItems : _desktopItems;
    final selectedIndex = isTablet ? 6 : 8;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          _buildRail(items, selectedIndex),
          Expanded(
            child: Center(
              child: Container(
                width: 935,
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: content,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRail(List<Map<String, dynamic>> items, int selectedIndex) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isRailHovered = true),
      onExit: (_) => setState(() {
        _isRailHovered = false;
        _hoveredRailIndex = -1;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: _isRailHovered
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          FaIcon(FontAwesomeIcons.instagram, size: 28),
                          SizedBox(width: 12),
                          Text(
                            'Instagram',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : const FaIcon(FontAwesomeIcons.instagram, size: 28),
              ),
            ),
            const SizedBox(height: 8),
            ...items.asMap().entries.map(
              (e) => _RailItem(
                icon: e.value['icon'] as Widget,
                label: e.value['label'] as String,
                selected: e.key == selectedIndex,
                showLabel: _isRailHovered,
                isHovered: _hoveredRailIndex == e.key,
                onTap: () {},
                onEnter: () => setState(() => _hoveredRailIndex = e.key),
                onExit: () => setState(() => _hoveredRailIndex = -1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
