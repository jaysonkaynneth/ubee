import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  final RxBool isDarkMode = false.obs;
  static const String _themeKey = 'isDarkMode';

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool(_themeKey) ?? false;
  }

  Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode.value);
  }
}

class AppColors {
  static final _themeController = Get.find<ThemeController>();

  static const Color primary = Color(0xFFD35F1D);
  static const Color secondary = Color(0xFFFFB800);
  static const Color accent = Color(0xFFFFF3E0);

  static const Color _lightBackground = Color(0xFFFFF8F0);
  static const Color _lightCardBackground = Color(0xFFFFFFFF);
  static const Color _lightTextPrimary = Color(0xFF1A1A1A);
  static const Color _lightTextSecondary = Color(0xFF757575);

  static const Color _darkBackground = Color(0xFF1A1A1A);
  static const Color _darkCardBackground = Color(0xFF2D2D2D);
  static const Color _darkTextPrimary = Color(0xFFFFFFFF);
  static const Color _darkTextSecondary = Color(0xFFB0B0B0);

  static Color get background =>
      _themeController.isDarkMode.value ? _darkBackground : _lightBackground;

  static Color get cardBackground =>
      _themeController.isDarkMode.value
          ? _darkCardBackground
          : _lightCardBackground;

  static Color get textPrimary =>
      _themeController.isDarkMode.value ? _darkTextPrimary : _lightTextPrimary;

  static Color get textSecondary =>
      _themeController.isDarkMode.value
          ? _darkTextSecondary
          : _lightTextSecondary;

  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE57373);
  static const Color disabled = Color(0xFFE0E0E0);

  static const List<Color> primaryGradient = [
    Color(0xFFD35F1D),
    Color(0xFFE67E22),
  ];

  static const Color sliderActive = primary;
  static const Color sliderInactive = Color(0xFFFFE0B2);
  static const Color playButtonBackground = secondary;
  static const Color captionHighlight = primary;
  static Color get captionNormal => textPrimary;
}
