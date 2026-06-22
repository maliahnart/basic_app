import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/constants.dart';
import '../providers/tts_provider.dart';
import '../providers/history_provider.dart';

class PlaybackScreen extends ConsumerStatefulWidget {
  const PlaybackScreen({super.key});

  @override
  ConsumerState<PlaybackScreen> createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends ConsumerState<PlaybackScreen> {
  final TextEditingController _controller = TextEditingController();
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _charCount = _controller.text.length;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ttsState = ref.watch(ttsProvider);
    final ttsNotifier = ref.read(ttsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Phát âm', style: AppTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 16.h,
                bottom: 80.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildLangChip(
                        'Tiếng Việt',
                        isActive: ttsState.currentLanguage == 'vi-VN',
                        onTap: () => ttsNotifier.setLanguage('vi-VN'),
                      ),
                      SizedBox(width: 8.w),
                      _buildLangChip(
                        'Tiếng Anh',
                        isActive: ttsState.currentLanguage == 'en-US',
                        onTap: () => ttsNotifier.setLanguage('en-US'),
                      ),
                      SizedBox(width: 8.w),
                      _buildLangChip(
                        'Tiếng Nhật',
                        isActive: ttsState.currentLanguage == 'ja-JP',
                        onTap: () => ttsNotifier.setLanguage('ja-JP'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    height: 180.h,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.border, width: 0.5),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            maxLength: 2000,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: 'Nhập nội dung...',
                              hintStyle: AppTextStyles.labelGrey,
                              border: InputBorder.none,
                              counterText: '',
                            ),
                            style: AppTextStyles.bodyDark,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$_charCount / 2000 ký tự',
                              style: AppTextStyles.labelGrey,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: AppColors.textGrey,
                              ),
                              onPressed: () => _controller.clear(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMediaSubButton(
                        Icons.stop_rounded,
                        onTap: () => ttsNotifier.stop(),
                      ),
                      SizedBox(width: 24.w),
                      Container(
                        width: 64.w,
                        height: 64.w,
                        decoration: BoxDecoration(
                          color: ttsState.isPlaying
                              ? AppColors.danger
                              : AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            ttsState.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 36.w,
                          ),
                          onPressed: () => ttsState.isPlaying
                              ? ttsNotifier.stop()
                              : ttsNotifier.speak(_controller.text),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  _buildSliderCard(
                    'Chỉnh tốc độ',
                    '${ttsState.speedRate.toStringAsFixed(1)}x',
                    ttsState.speedRate,
                    0.5,
                    2.0,
                    (v) => ttsNotifier.setSpeed(v),
                  ),
                  SizedBox(height: 10.h),
                  _buildSliderCard(
                    'Chỉnh cao độ (Pitch)',
                    ttsState.pitch.toStringAsFixed(1),
                    ttsState.pitch,
                    0.5,
                    2.0,
                    (v) => ttsNotifier.setPitch(v),
                  ),
                  SizedBox(height: 10.h),
                  _buildSliderCard(
                    'Âm lượng (Volume)',
                    '${(ttsState.volume * 100).toInt()}%',
                    ttsState.volume,
                    0.0,
                    1.0,
                    (v) => ttsNotifier.setVolume(v),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 16.h,
              right: 20.w,
              child: FloatingActionButton.extended(
                backgroundColor: AppColors.primary,
                onPressed: _controller.text.trim().isEmpty
                    ? null
                    : () async {
                        await ref
                            .read(historyProvider.notifier)
                            .saveRecords(text: _controller.text, isStt: false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đã lưu bản ghi thành công!'),
                          ),
                        );
                      },
                icon: const Icon(Icons.save_rounded, color: Colors.white),
                label: Text(
                  'Lưu bản ghi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLangChip(
    String text, {
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive ? AppColors.activeChipBg : AppColors.inactiveChipBg,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          text,
          style: isActive
              ? AppTextStyles.chipActive
              : AppTextStyles.chipInactive,
        ),
      ),
    );
  }

  Widget _buildMediaSubButton(IconData icon, {required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
        color: Colors.white,
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.textDark, size: 22.w),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildSliderCard(
    String title,
    String valText,
    double currentVal,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.labelBoldDark),
              Text(valText, style: AppTextStyles.labelBoldPrimary),
            ],
          ),
          Slider(
            value: currentVal,
            min: min,
            max: max,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.border,
          ),
        ],
      ),
    );
  }
}
