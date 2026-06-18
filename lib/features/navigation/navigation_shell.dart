import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../home/home_screen.dart';
import '../catalog/catalog_screen.dart';
import '../favorites/favorites_screen.dart';
import '../profile/profile_screen.dart';

class NavigationShell extends StatefulWidget {
  const NavigationShell({super.key});

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  int _currentIndex = 0;
  String? _deepLinkCategoryId;

  void _onTabTapped(int index, String? categoryId) {
    setState(() {
      _currentIndex = index;
      _deepLinkCategoryId = categoryId;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Pages List
    final List<Widget> pages = [
      HomeScreen(
        onNavigateToTab: (index, categoryId) => _onTabTapped(index, categoryId),
      ),
      CatalogScreen(
        initialCategoryId: _deepLinkCategoryId,
      ),
      const FavoritesScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AgroTheme.background,
      body: Stack(
        children: [
          // Current Selected Page
          IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
          // Floating Bottom Navigation Bar
          Positioned(
            bottom: 24,
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: AgroTheme.surface.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AgroTheme.border.withOpacity(0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(0, Icons.home_outlined, Icons.home, "Bosh sahifa"),
                      _buildNavItem(1, Icons.grid_view, Icons.grid_view_rounded, "Katalog"),
                      _buildNavItem(2, Icons.favorite_border, Icons.favorite, "Saralangan"),
                      _buildNavItem(3, Icons.person_outline, Icons.person, "Profil"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlineIcon, IconData solidIcon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
          if (index != 1) {
            _deepLinkCategoryId = null; // reset category deep links if clicking away from catalog
          }
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? AgroTheme.primary.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              isSelected ? solidIcon : outlineIcon,
              color: isSelected ? AgroTheme.primary : AgroTheme.textSecondary,
              size: 22,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AgroTheme.primary : AgroTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
