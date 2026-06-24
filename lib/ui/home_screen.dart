import 'package:demo_app/providers/history_provider.dart';
import 'package:demo_app/ui/widgets/record_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _dropdownKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToDropdown(bool isExpanded) {
    if (isExpanded) {
      Future.delayed(const Duration(milliseconds: 250), () {
        final context = _dropdownKey.currentContext;
        if (context != null) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            alignment: 0.0,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final recentRecords = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Chuyển Đổi Giọng Nói', style: AppTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
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
                onTap: () => context.go('/record'),
              ),
              SizedBox(height: 16.h),
              _buildFeatureCard(
                title: 'Chuyển đổi Văn bản\nsang Giọng nói',
                actionText: 'Nhập văn bản',
                icon: Icons.volume_up,
                iconBgColor: AppColors.ttsIconBg,
                onTap: () => context.go('/playback'),
              ),
              SizedBox(height: 28.h),
              Container(
                key: _dropdownKey,
                child: _buildRecentCollapsible(recentRecords, ref, context),
              ),
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

  Widget _buildRecentCollapsible(
    List recentRecords,
    WidgetRef ref,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          title: Text(
            'Bản ghi gần đây',
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 16.sp),
          ),
          leading: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.history, color: AppColors.primary, size: 20.w),
          ),
          trailing: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textGrey,
          ),
          childrenPadding: EdgeInsets.only(
            left: 12.w,
            right: 12.w,
            bottom: 12.h,
          ),
          shape: const Border(),
          collapsedShape: const Border(),
          onExpansionChanged: (isExpanded) {
            ref.read(historyProvider.notifier).loadRecords();
            _scrollToDropdown(isExpanded);
          },

          children: [_buildRecentList(recentRecords, ref, context)],
        ),
      ),
    );
  }

  Widget _buildRecentList(
    List recentRecords,
    WidgetRef ref,
    BuildContext context,
  ) {
    if (recentRecords.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Text('Chưa có bản ghi nào', style: AppTextStyles.labelGrey),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentRecords.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final item = recentRecords[index];
        final timeStr = DateFormat('HH:mm - dd/MM').format(item.createAt);

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
                item.isStt
                    ? Icons.description_outlined
                    : Icons.volume_up_outlined,
                color: AppColors.textGrey,
                size: 20.w,
              ),
            ),
            title: Text(
              item.text,
              style: AppTextStyles.itemTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${timeStr.toUpperCase()} - ${item.isStt ? "STT" : "TTS"}',
              style: AppTextStyles.itemSub,
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.textGrey),
              onSelected: (value) {
                if (value == 'delete') {
                  ref.read(historyProvider.notifier).deleteRecords(index);
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    'Xóa bản ghi',
                    style: TextStyle(color: AppColors.danger),
                  ),
                ),
              ],
            ),
            onTap: () {
              RecordDetailBottomSheet.show(
                context,
                title: item.text,
                date: timeStr,
                content: item.text,
                isStt: item.isStt,
              );
            },
          ),
        );
      },
    );
  }
}
