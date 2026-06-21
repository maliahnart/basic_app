import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Chuyển Đổi Giọng Nói', style: AppTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreeting(),
              SizedBox(height: 24.h),
              _buildFeatureCard(
                title: 'Chuyển đổi Giọng nói\nsang Văn bản',
                actionText: 'Ghi âm ngay',
                icon: Icons.mic,
                iconBgColor: AppColors.sttIconBg,
                onTap: () {
                  context.push('/record');
                },
              ),
              SizedBox(height: 16.h),
              _buildFeatureCard(
                title: 'Chuyển đổi Văn bản\nsang Giọng nói',
                actionText: 'Nhập văn bản',
                icon: Icons.volume_up,
                iconBgColor: AppColors.ttsIconBg,
                onTap: () {
                  context.push('/playback');
                },
              ),
              SizedBox(height: 28.h),
              _buildRecentSection(),
              SizedBox(height: 12.h),
              _buildRecentList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Xin chào!', style: AppTextStyles.greetingTitle),
        SizedBox(height: 4.h),
        Text(
          'Hôm nay bạn muốn xử lý âm thanh như thế nào?',
          style: AppTextStyles.greetingSub,
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String actionText,
    required IconData icon,
    required Color iconBgColor,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: Colors.white, size: 24.w),
              ),
              SizedBox(height: 20.h),
              Text(title, style: AppTextStyles.cardTitle),
              SizedBox(height: 12.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(actionText, style: AppTextStyles.cardAction),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.arrow_forward,
                    color: AppColors.primary,
                    size: 16.w,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Gần đây', style: AppTextStyles.sectionTitle),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Text('Xem tất cả', style: AppTextStyles.sectionAction),
        ),
      ],
    );
  }

  Widget _buildRecentList() {
    final mockData = [
      {
        'title': 'Cuộc họp dự án AI 2024...',
        'sub': 'HÔM NAY - STT',
        'isStt': true,
      },
      {
        'title': 'Thông báo khách hàng v1',
        'sub': 'HÔM QUA - TTS',
        'isStt': false,
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: mockData.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final item = mockData[index];
        return Container(
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 4.h,
            ),
            leading: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                item['isStt'] as bool
                    ? Icons.description_outlined
                    : Icons.volume_up_outlined,
                color: AppColors.textGrey,
                size: 20.w,
              ),
            ),
            title: Text(
              item['title'] as String,
              style: AppTextStyles.itemTitle,
            ),
            subtitle: Text(item['sub'] as String, style: AppTextStyles.itemSub),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert, color: AppColors.textGrey),
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }
}
