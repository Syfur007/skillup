import 'package:flutter/material.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../explore/screens/roadmap_list_screen.dart';
import '../../profile/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardScreen(),
    RoadmapListScreen(),
    // groups placeholder (replace with real screen when available)
    _GroupsPlaceholder(),
    ProfileScreen(),
  ];

  static const List<String> _titles = [
    'Dashboard',
    'Explore',
    'Groups',
    'Profile',
  ];

  void _onTap(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          if (_selectedIndex == 1)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // hook: implement search in roadmap list screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Open roadmap search')),
                );
              },
            ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                // quick action: navigate to explore
                setState(() => _selectedIndex = 1);
              },
              tooltip: 'Explore roadmaps',
              child: const Icon(Icons.explore),
            )
          : null,
    );
  }
}

class _GroupsPlaceholder extends StatelessWidget {
  const _GroupsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.group, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text('Groups feature coming soon', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
