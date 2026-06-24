import 'package:demo_app/providers/history_provider.dart';
import 'package:demo_app/providers/stt_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/constants.dart';

class RecordScreen extends ConsumerWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sttState = ref.watch(sttProvider);
    final sttNotifier = ref.read(sttProvider.notifier);
    ref.listen(sttProvider.select((s) => s.errorMessage), (prev, next) {
      if (next.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next)));
      }
    });
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  PopupMenuButton<AppLanguage>(
                    enabled: !sttState.isListening,
                    initialValue: sttState.currentLanguage,
                    onSelected: (AppLanguage lang) {
                      sttNotifier.setLanguage(lang);
                    },
                    itemBuilder: (BuildContext context) {
                      return AppLanguages.supported.map((AppLanguage lang) {
                        return PopupMenuItem(
                          value: lang,
                          child: Row(
                            children: [
                              Text(
                                lang.flag,
                                style: TextStyle(fontSize: 16.sp),
                              ),
                              SizedBox(width: 8.w),
                              Text(lang.name, style: AppTextStyles.bodyDark),
                            ],
                          ),
                        );
                      }).toList();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: sttState.isListening
                            ? AppColors.danger.withOpacity(0.1)
                            : AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          Text(
                            sttState.currentLanguage.flag,
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            sttState.currentLanguage.name,
                            style: TextStyle(
                              color: sttState.isListening
                                  ? AppColors.danger
                                  : AppColors.primary,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Icon(
                            Icons.arrow_drop_down,
                            color: sttState.isListening
                                ? AppColors.danger
                                : AppColors.primary,
                            size: 16.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    sttState.isListening ? 'Đang lắng nghe' : 'Sẵn sàng ghi âm',
                    style: AppTextStyles.statusText,
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
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
                            'KẾT QUẢ THỜI GIAN THỰC',
                            style: AppTextStyles.labelGrey.copyWith(
                              letterSpacing: 0.5,
                            ),
                          ),
                          Row(
                            children: [
                              TextButton.icon(
                                onPressed: sttState.currentText.isNotEmpty
                                    ? () {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: sttState.currentText,
                                          ),
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Đã sao chép!'),
                                          ),
                                        );
                                      }
                                    : null,
                                icon: Icon(
                                  Icons.copy_rounded,
                                  size: 16.w,
                                  color: AppColors.primary,
                                ),
                                label: Text(
                                  'Sao chép',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              TextButton.icon(
                                onPressed: sttState.currentText.isNotEmpty
                                    ? () => sttNotifier.clearText()
                                    : null,
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  size: 16.w,
                                  color: AppColors.danger,
                                ),
                                label: Text(
                                  'Xóa',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.danger,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            sttState.currentText.isEmpty
                                ? 'Nội dung nói sẽ hiển thị tại đây...'
                                : sttState.currentText,
                            style: sttState.currentText.isEmpty
                                ? AppTextStyles.bodyDark.copyWith(
                                    color: AppColors.textGrey,
                                  )
                                : AppTextStyles.bodyDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40.h),

              Center(
                child: GestureDetector(
                  onTap: () async {
                    bool currentlyListening = sttState.isListening;
                    await sttNotifier.toggleRecording();

                    if (currentlyListening &&
                        sttState.currentText.trim().isNotEmpty) {
                      await ref
                          .read(historyProvider.notifier)
                          .saveRecords(text: sttState.currentText, isStt: true);
                      sttNotifier.clearText();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đã lưu bản ghi vào Gần đây!'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 72.w,
                    height: 72.w,
                    decoration: BoxDecoration(
                      color: sttState.isListening
                          ? AppColors.danger
                          : AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              (sttState.isListening
                                      ? AppColors.danger
                                      : AppColors.primary)
                                  .withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      sttState.isListening ? Icons.stop : Icons.mic,
                      color: Colors.white,
                      size: 32.w,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Text('Chuyển Đổi Giọng Nói', style: AppTextStyles.appBarTitle),
      centerTitle: true,
    );
  }
}
