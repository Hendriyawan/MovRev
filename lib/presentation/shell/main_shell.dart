import 'package:flutter/material.dart';
import 'package:movrev/presentation/favorite/favorite_page.dart';
import 'package:movrev/presentation/now_playing/now_playing_page.dart';
import 'package:movrev/presentation/popular/popular_page.dart';
import 'package:movrev/presentation/upcoming/upcoming_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          NowPlayingPage(),
          UpcomingPage(),
          PopularPage(),
          FavoritePage(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.play_circle, "Now Playing"),
              _buildNavItem(1, Icons.upcoming_rounded, "Upcoming"),
              _buildNavItem(2, Icons.trending_up_outlined, "Popular"),
              _buildNavItem(3, Icons.favorite, "Favorite"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String title) {
    final isSelected = _currentIndex == index;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final unselectedColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? primaryColor : unselectedColor),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? primaryColor : unselectedColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
