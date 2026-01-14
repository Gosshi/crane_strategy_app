import 'package:flutter/material.dart';

/// レスポンシブデザイン用のユーティリティクラス
class ResponsiveUtils {
  /// 画面の幅のブレークポイント
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 900;
  static const double desktopMinWidth = 900;

  /// モバイルデバイスかどうか
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileMaxWidth;
  }

  /// タブレットデバイスかどうか
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileMaxWidth && width < desktopMinWidth;
  }

  /// デスクトップデバイスかどうか
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopMinWidth;
  }

  /// グリッドのカラム数を取得（画面サイズに応じて）
  static int getGridColumnCount(
    BuildContext context, {
    int mobile = 3,
    int tablet = 5,
    int desktop = 7,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return mobile;
  }

  /// 水平パディングを取得（画面サイズに応じて）
  static double getHorizontalPadding(BuildContext context) {
    if (isDesktop(context)) return 48;
    if (isTablet(context)) return 32;
    return 16;
  }

  /// 垂直パディングを取得（画面サイズに応じて）
  static double getVerticalPadding(BuildContext context) {
    if (isDesktop(context)) return 32;
    if (isTablet(context)) return 24;
    return 16;
  }

  /// リストビューの最大幅を取得（大画面で読みやすくする）
  static double getContentMaxWidth(BuildContext context) {
    if (isDesktop(context)) return 1200;
    if (isTablet(context)) return 900;
    return double.infinity;
  }

  /// 画面の向きが横向きかどうか
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// デバイスタイプに応じた値を返す
  static T getValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile;
  }

  /// 詳細画面のレイアウトタイプを取得
  static DetailLayoutType getDetailLayoutType(BuildContext context) {
    // iPadの横向きまたはデスクトップの場合は横並び
    if (isDesktop(context) || (isTablet(context) && isLandscape(context))) {
      return DetailLayoutType.sideBySide;
    }
    return DetailLayoutType.vertical;
  }
}

/// 詳細画面のレイアウトタイプ
enum DetailLayoutType {
  /// 縦並び（モバイル）
  vertical,

  /// 横並び（タブレット・デスクトップ）
  sideBySide,
}
