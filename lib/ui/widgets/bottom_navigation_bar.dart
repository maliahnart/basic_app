import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../utils/constants.dart';

class BottomNavigation extends StatelessWidget {
  final Widget child;

  const BottomNavigation({super.key, required this.child});

  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/record')) return 1;
    if (location.startsWith('/playback')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0; 
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/record');
        break;
      case 2:
        context.go('/playback');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child, 
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textGrey,
        currentIndex: _getSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        selectedLabelStyle: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
        ),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.mic_none), label: 'Ghi âm'),
          BottomNavigationBarItem(
            icon: Icon(Icons.volume_up_outlined),
            label: 'Văn bản',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }
}
