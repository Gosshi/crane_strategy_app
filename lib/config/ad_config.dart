import 'dart:io';
import 'package:flutter/foundation.dart';

/// AdMob広告ユニットIDの設定
///
/// テストモード（kDebugMode）では Google提供のテスト広告IDを使用
/// 本番モードでは実際の広告ユニットIDを使用
class AdConfig {
  /// テストモードフラグ
  /// Debug modeではテスト広告を表示し、Release modeでは本番広告を表示
  static const bool isTestMode = kDebugMode;

  // ========================================
  // iOS広告ユニットID
  // ========================================

  /// iOS バナー広告ユニットID
  static const String iosBannerAdUnitId = isTestMode
      ? 'ca-app-pub-3940256099942544/2934735716' // Googleテスト広告ID
      : 'ca-app-pub-5037180740248986/3751138129'; // 本番ID

  /// iOS インタースティシャル広告ユニットID
  static const String iosInterstitialAdUnitId = isTestMode
      ? 'ca-app-pub-3940256099942544/4411468910'
      : 'ca-app-pub-5037180740248986/3438795864'; // 本番ID

  /// iOS リワード広告ユニットID
  static const String iosRewardedAdUnitId = isTestMode
      ? 'ca-app-pub-3940256099942544/1712485313'
      : 'ca-app-pub-5037180740248986/5559043810'; // 本番ID

  // ========================================
  // Android広告ユニットID
  // ========================================

  /// Android バナー広告ユニットID
  static const String androidBannerAdUnitId = isTestMode
      ? 'ca-app-pub-3940256099942544/6300978111' // Googleテスト広告ID
      : 'ca-app-pub-5037180740248986/4130072769'; // 本番ID

  /// Android インタースティシャル広告ユニットID
  static const String androidInterstitialAdUnitId = isTestMode
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-5037180740248986/3886869491'; // 本番ID

  /// Android リワード広告ユニットID
  static const String androidRewardedAdUnitId = isTestMode
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-5037180740248986/6827376530'; // 本番ID

  // ========================================
  // プラットフォーム別広告ユニットID取得
  // ========================================

  /// 現在のプラットフォームに対応するバナー広告ユニットIDを取得
  static String get bannerAdUnitId =>
      Platform.isIOS ? iosBannerAdUnitId : androidBannerAdUnitId;

  /// 現在のプラットフォームに対応するインタースティシャル広告ユニットIDを取得
  static String get interstitialAdUnitId =>
      Platform.isIOS ? iosInterstitialAdUnitId : androidInterstitialAdUnitId;

  /// 現在のプラットフォームに対応するリワード広告ユニットIDを取得
  static String get rewardedAdUnitId =>
      Platform.isIOS ? iosRewardedAdUnitId : androidRewardedAdUnitId;
}
