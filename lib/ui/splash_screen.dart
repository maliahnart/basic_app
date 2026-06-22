import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart' as rive;
import '../models/voice_record.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isCoreInitialized = false;
  bool _isNavigating = false;

  late final rive.FileLoader _fileLoader;

  @override
  void initState() {
    super.initState();

    _fileLoader = rive.FileLoader.fromAsset(
      'assets/rives/TTS.riv',
      riveFactory: rive.Factory.rive,
    );

    _initializeApp();
  }

  @override
  void dispose() {
    _fileLoader.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    try {
      await Hive.initFlutter();

      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(VoiceRecordAdapter());
      }

      if (!Hive.isBoxOpen('history')) {
        try {
          await Hive.openBox<VoiceRecord>('history');
        } catch (e) {
          debugPrint('Box corrupt, tạo lại: $e');
          await Hive.deleteBoxFromDisk('history');
          await Hive.openBox<VoiceRecord>('history');
        }
      }
      await Future.any([
        Future.delayed(const Duration(milliseconds: 2500)),
        Future.delayed(const Duration(seconds: 5)),
      ]);

      _isCoreInitialized = true;
    } catch (e) {
      debugPrint("Lỗi khởi tạo hệ thống: $e");
      _isCoreInitialized = true;
    } finally {
      if (mounted) {
        _navigateToNextScreen();
      }
    }
  }

  void _navigateToNextScreen() {
    if (!mounted || _isNavigating) return;
    if (_isCoreInitialized) {
      _isNavigating = true;
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.all(10.w),
          child: rive.RiveWidgetBuilder(
            fileLoader: _fileLoader,
            builder: (context, state) {
              return switch (state) {
                rive.RiveLoading() => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                rive.RiveFailed() => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.red,
                      ),
                      SizedBox(height: 16.h),
                      const Text(
                        'Không thể tải animation',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                rive.RiveLoaded() => rive.RiveWidget(
                  controller: state.controller,
                  fit: rive.Fit.contain,
                ),
              };
            },
          ),
        ),
      ),
    );
  }
}
