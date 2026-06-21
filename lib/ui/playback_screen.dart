import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/constants.dart';

class PlaybackScreen extends StatelessWidget {
  const PlaybackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
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
                      _buildLangChip('Tiếng Việt', isActive: true),
                      SizedBox(width: 8.w),
                      _buildLangChip('Tiếng Anh', isActive: false),
                      SizedBox(width: 8.w),
                      _buildLangChip('Tiếng Nhật', isActive: false),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Khung Nhập Văn Bản
                  Container(
                    height: 220.h,
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
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText:
                                  'Nhập nội dung bạn muốn chuyển thành giọng nói tại đây...',
                              hintStyle: AppTextStyles.labelGrey.copyWith(
                                fontSize: 13.sp,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            style: AppTextStyles.bodyDark,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '0 / 2000 ký tự',
                              style: AppTextStyles.labelGrey.copyWith(
                                fontSize: 11.sp,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.copy_rounded,
                                size: 18.w,
                                color: AppColors.textGrey,
                              ),
                              onPressed: () {},
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Bộ nút điều khiển media (Stop - Play - Replay)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMediaSubButton(Icons.stop_rounded, onTap: () {}),
                      SizedBox(width: 24.w),
                      Container(
                        width: 64.w,
                        height: 64.w,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 36.w,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(width: 24.w),
                      _buildMediaSubButton(Icons.replay_rounded, onTap: () {}),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Khung Điều chỉnh Tốc độ (Speech Rate)
                  _buildSliderConfigCard(
                    title: 'Chỉnh tốc độ',
                    valueText: '1.0x',
                    value: 0.5,
                    leftLabel: 'Chậm',
                    centerLabel: 'Bình thường',
                    rightLabel: 'Nhanh',
                  ),
                  SizedBox(height: 12.h),

                  // Khung Điều chỉnh Cao độ (Pitch) - Add thêm theo yêu cầu
                  _buildSliderConfigCard(
                    title: 'Chỉnh cao độ (Pitch)',
                    valueText: '1.0',
                    value: 0.5,
                    leftLabel: 'Trầm',
                    centerLabel: 'Mặc định',
                    rightLabel: 'Bổng',
                  ),
                  SizedBox(height: 16.h),

                  // Card Chọn Giọng Đọc
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.border, width: 0.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.face_retouching_natural,
                            color: AppColors.primary,
                            size: 20.w,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Giọng Ban Mai',
                                style: AppTextStyles.labelBoldDark,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Nữ - Miền Bắc',
                                style: AppTextStyles.labelGrey.copyWith(
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Thay đổi',
                            style: AppTextStyles.labelBoldPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Nút lưu nổi ở góc dưới cùng bên phải theo yêu cầu
            Positioned(
              bottom: 16.h,
              right: 20.w,
              child: FloatingActionButton.extended(
                backgroundColor: AppColors.primary,
                elevation: 3,
                onPressed: () {},
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Text('Phát âm', style: AppTextStyles.appBarTitle),
      centerTitle: true,
    );
  }

  Widget _buildLangChip(String text, {required bool isActive}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isActive ? AppColors.activeChipBg : AppColors.inactiveChipBg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: isActive ? AppTextStyles.chipActive : AppTextStyles.chipInactive,
      ),
    );
  }

  Widget _buildMediaSubButton(IconData icon, {required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border, width: 1),
        color: Colors.white,
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.textDark, size: 22.w),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildSliderConfigCard({
    required String title,
    required String valueText,
    required double value,
    required String leftLabel,
    required String centerLabel,
    required String rightLabel,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.speed_rounded,
                    size: 16.w,
                    color: AppColors.textDark,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    title,
                    style: AppTextStyles.labelBoldDark.copyWith(
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
              Text(valueText, style: AppTextStyles.labelBoldPrimary),
            ],
          ),
          SizedBox(height: 8.h),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4.h,
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.border,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withOpacity(0.1),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
            ),
            child: Slider(value: value, onChanged: (val) {}),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  leftLabel,
                  style: AppTextStyles.labelGrey.copyWith(fontSize: 10.sp),
                ),
                Text(
                  centerLabel,
                  style: AppTextStyles.labelGrey.copyWith(fontSize: 10.sp),
                ),
                Text(
                  rightLabel,
                  style: AppTextStyles.labelGrey.copyWith(fontSize: 10.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
