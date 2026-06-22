import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/constants.dart';
import '../../providers/tts_provider.dart';

class RecordDetailBottomSheet {
  static void show(
    BuildContext context, {
    required String title,
    required String date,
    required String content,
    required bool isStt,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BottomSheetContent(
        title: title,
        date: date,
        content: content,
        isStt: isStt,
      ),
    );
  }
}

class _BottomSheetContent extends ConsumerWidget {
  final String title;
  final String date;
  final String content;
  final bool isStt;

  const _BottomSheetContent({
    required this.title,
    required this.date,
    required this.content,
    required this.isStt,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ttsState = ref.watch(ttsProvider);
    final ttsNotifier = ref.read(ttsProvider.notifier);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 16.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.cardTitle.copyWith(
                          fontSize: 18.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '$date - ${isStt ? "SPEECH TO TEXT" : "TEXT TO SPEECH"}',
                        style: AppTextStyles.itemSub,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: const BoxDecoration(
                      color: AppColors.inactiveChipBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 18.w,
                      color: AppColors.textGrey,
                    ),
                  ),
                  onPressed: () {
                    ttsNotifier.stop();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          const Divider(color: AppColors.border, thickness: 0.5),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'NỘI DUNG BẢN GHI',
                          style: AppTextStyles.labelGrey.copyWith(
                            letterSpacing: 0.5,
                          ),
                        ),
                        Icon(
                          Icons.copy_rounded,
                          size: 18.w,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Text(content, style: AppTextStyles.bodyDark),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 16.h,
              bottom: 24.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 54.w,
                      height: 54.w,
                      decoration: BoxDecoration(
                        color: ttsState.isPlaying
                            ? AppColors.danger
                            : AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          ttsState.isPlaying
                              ? Icons.stop_rounded
                              : Icons.volume_up_rounded,
                          color: Colors.white,
                          size: 26.w,
                        ),
                        onPressed: () {
                          if (ttsState.isPlaying) {
                            ttsNotifier.stop();
                          } else {
                            ttsNotifier.speak(content); 
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  ttsState.isPlaying
                      ? 'Đang đọc bản ghi...'
                      : 'Bấm nút loa để nghe lại bản ghi',
                  style: AppTextStyles.labelGrey.copyWith(fontSize: 11.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
