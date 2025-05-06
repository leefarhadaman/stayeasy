import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find();
    final List<Widget> screens = [
      const HomeScreen(),
      const ExploreScreen(),
      const FavoritesScreen(),
      const ProfileScreen(),
    ];

    return Obx(() => Scaffold(
      body: screens[controller.selectedTab.value],
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: _buildPremiumNavBar(controller, context),
      ),
      floatingActionButton: controller.selectedTab.value != 3
          ? FloatingActionButton(
        onPressed: () => _showQuickActionSheet(context),
        backgroundColor: const Color(0xFF5E8B7E),
        elevation: 2,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      )
          : null,
    ));
  }

  Widget _buildPremiumNavBar(AppController controller, BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.9),
            Colors.white.withOpacity(0.7),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                controller: controller,
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
              ),
              _buildNavItem(
                context: context,
                controller: controller,
                index: 1,
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
                label: 'Explore',
              ),
              _buildNavItem(
                context: context,
                controller: controller,
                index: 2,
                icon: Icons.favorite_border,
                activeIcon: Icons.favorite,
                label: 'Favorites',
                showBadge: true,
              ),
              _buildNavItem(
                context: context,
                controller: controller,
                index: 3,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required AppController controller,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    bool showBadge = false,
  }) {
    bool isSelected = controller.selectedTab.value == index;
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [
              const Color(0xFF5E8B7E).withOpacity(0.2),
              const Color(0xFF5E8B7E).withOpacity(0.1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
              : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    color: isSelected ? const Color(0xFF5E8B7E) : Colors.grey[400],
                    size: isSelected ? 28 : 26,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF5E8B7E) : Colors.grey[400],
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (showBadge && isSelected) _buildNotificationBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationBadge() {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
        ),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: const Center(
        child: Text(
          '2',
          style: TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showQuickActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    icon: Icons.search,
                    label: 'Search',
                    color: const Color(0xFFDEF5E5),
                    iconColor: const Color(0xFF5E8B7E),
                    onTap: () {
                      Get.back();
                      Get.toNamed('/explore');
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.schedule,
                    label: 'Schedule',
                    color: const Color(0xFFBCCEF8),
                    iconColor: const Color(0xFF5B8CFF),
                    onTap: () {
                      Get.back();
                      Get.snackbar('Schedule', 'Schedule visit feature coming soon!');
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.map,
                    label: 'Map View',
                    color: const Color(0xFFFFE5D9),
                    iconColor: const Color(0xFFFF9A76),
                    onTap: () {
                      Get.back();
                      Get.snackbar('Map', 'Map view feature coming soon!');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2D2D2D),
            ),
          ),
        ],
      ),
    );
  }
}