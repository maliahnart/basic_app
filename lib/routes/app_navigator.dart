import 'package:demo_app/ui/home_screen.dart';
import 'package:demo_app/ui/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
part 'route.dart';

// Khởi tạo các Placeholder cho các màn hình còn lại để không bị lỗi compile
class RecordScreen extends StatelessWidget { const RecordScreen({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Ghi âm'))); }
class PlaybackScreen extends StatelessWidget { const PlaybackScreen({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Phát âm'))); }
class SettingsScreen extends StatelessWidget { const SettingsScreen({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Cài đặt'))); }

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return BottomNavigation(child: child);
      },
      routes: [
        GoRoute(
          path: Routes.home.path,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: Routes.record.path,
          builder: (context, state) => const RecordScreen(),
        ),
        GoRoute(
          path: Routes.playback.path,
          builder: (context, state) => const PlaybackScreen(),
        ),
        GoRoute(
          path: Routes.settings.path,
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);