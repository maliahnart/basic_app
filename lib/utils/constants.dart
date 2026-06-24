import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppColors {
  static const Color background = Color(0xFFF8FAFC);
  static const Color primary = Color(0xFF5D5FEF);
  static const Color primaryLight = Color(0xFFEEEEFF);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color splashBg = Color(0xFF0C0C0C);

  // Card STT & TTS
  static const Color sttIconBg = Color(0xFF6366F1);
  static const Color ttsIconBg = Color(0xFF065F46);
  static const Color ttsCardBg = Color(0xFFF0FDF4);

  static const Color cardBg = Colors.white;
  static const Color border = Color(0xFFE2E8F0);

  static const Color activeChipBg = Color(0xFF5D5FEF);
  static const Color inactiveChipBg = Color(0xFFF1F5F9);
  static const Color textLink = Color(0xFF5D5FEF);
  static const Color danger = Color(0xFFEF4444);
}

class AppTextStyles {
  static TextStyle get appBarTitle => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static TextStyle get greetingTitle => TextStyle(
    fontSize: 26.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static TextStyle get greetingSub => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textGrey,
    height: 1.4,
  );

  static TextStyle get cardTitle => TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static TextStyle get cardAction => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static TextStyle get sectionTitle => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static TextStyle get sectionAction => TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );

  static TextStyle get itemTitle => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static TextStyle get itemSub => TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textGrey,
  );
  static TextStyle get bodyDark => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
    height: 1.5,
  );
  static TextStyle get labelGrey => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textGrey,
  );
  static TextStyle get labelBoldDark => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );
  static TextStyle get labelBoldPrimary => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
  static TextStyle get statusText => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textGrey,
  );

  static TextStyle get chipActive => TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static TextStyle get chipInactive => TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textGrey,
  );
}

class AppLanguage {
  final String name;
  final String localeId;
  final String flag;

  const AppLanguage({
    required this.name,
    required this.localeId,
    required this.flag,
  });
}

class AppLanguages {
  static const List<AppLanguage> supported = [
    AppLanguage(name: 'Tiếng Việt', localeId: 'vi_VN', flag: '🇻🇳'),
    AppLanguage(name: 'Tiếng Anh', localeId: 'en_US', flag: '🇺🇸'),
    AppLanguage(name: 'Tiếng Nhật', localeId: 'ja_JP', flag: '🇯🇵'),
    AppLanguage(name: 'Tiếng Hàn', localeId: 'ko_KR', flag: '🇰🇷'),
    AppLanguage(name: 'Tiếng Trung', localeId: 'zh_CN', flag: '🇨🇳'),
  ];
}
