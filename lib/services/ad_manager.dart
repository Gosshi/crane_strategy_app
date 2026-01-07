import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/ad_config.dart';
import '../utils/logger.dart';

/// AdMob広告の管理クラス
///
/// シングルトンパターンで実装し、アプリ全体で広告を一元管理します。
/// バナー広告、インタースティシャル広告、リワード広告の読み込み・表示を担当します。
class AdManager {
  // シングルトンインスタンス
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  // インタースティシャル広告のインスタンス
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  // リワード広告のインスタンス
  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;

  // リワード広告の報酬とCompleter
  RewardItem? _earnedReward;
  Completer<RewardItem?>? _rewardCompleter;

  // 広告表示カウンター
  int _scanCount = 0;
  int _videoCount = 0;

  // 広告表示頻度の設定
  static const int _scanAdFrequency = 3; // スキャン3回に1回
  static const int _videoAdFrequency = 2; // 動画視聴2回に1回

  /// AdMob SDKの初期化
  ///
  /// アプリ起動時に一度だけ呼び出す必要があります。
  Future<void> initialize() async {
    try {
      await MobileAds.instance.initialize();
      logger.i('[AdManager] AdMob SDK initialized successfully');

      // インタースティシャル広告の事前読み込み
      await loadInterstitialAd();

      // リワード広告の事前読み込み
      await loadRewardedAd();
    } catch (e) {
      logger.e('[AdManager] Failed to initialize AdMob SDK', error: e);
    }
  }

  /// バナー広告の作成
  ///
  /// ホーム画面や用語集画面などで使用します。
  /// 作成したバナー広告は、AdWidgetでラップして表示します。
  BannerAd createBannerAd() {
    logger.d('[AdManager] Creating banner ad');

    return BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: AdSize.banner, // 320x50
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          logger.i('[AdManager] Banner ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          logger.e(
            '[AdManager] Banner ad failed to load: ${error.message}',
            error: error,
          );
          ad.dispose();
        },
        onAdOpened: (ad) {
          logger.d('[AdManager] Banner ad opened');
        },
        onAdClosed: (ad) {
          logger.d('[AdManager] Banner ad closed');
        },
      ),
    )..load();
  }

  /// インタースティシャル広告の読み込み
  ///
  /// スキャン結果画面や動画視聴後に表示する全画面広告です。
  Future<void> loadInterstitialAd() async {
    if (_isInterstitialAdReady) {
      logger.d('[AdManager] Interstitial ad already loaded');
      return;
    }

    try {
      await InterstitialAd.load(
        adUnitId: AdConfig.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            logger.i('[AdManager] Interstitial ad loaded');
            _interstitialAd = ad;
            _isInterstitialAdReady = true;

            // 広告が閉じられたときの処理
            _interstitialAd!
                .fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                logger.d('[AdManager] Interstitial ad dismissed');
                ad.dispose();
                _interstitialAd = null;
                _isInterstitialAdReady = false;

                // 次の広告を事前読み込み
                loadInterstitialAd();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                logger.e(
                  '[AdManager] Interstitial ad failed to show: ${error.message}',
                  error: error,
                );
                ad.dispose();
                _interstitialAd = null;
                _isInterstitialAdReady = false;

                // 次の広告を事前読み込み
                loadInterstitialAd();
              },
            );
          },
          onAdFailedToLoad: (error) {
            logger.e(
              '[AdManager] Interstitial ad failed to load: ${error.message}',
              error: error,
            );
            _isInterstitialAdReady = false;
          },
        ),
      );
    } catch (e) {
      logger.e('[AdManager] Exception loading interstitial ad', error: e);
    }
  }

  /// インタースティシャル広告の表示（頻度管理付き）
  ///
  /// [type] 'scan' または 'video' を指定
  /// - scan: スキャン3回に1回表示
  /// - video: 動画視聴2回に1回表示
  Future<void> showInterstitialAdIfReady({required String type}) async {
    // カウンターを増やす
    if (type == 'scan') {
      _scanCount++;
      logger.d('[AdManager] Scan count: $_scanCount');

      // 指定回数に達したら広告を表示
      if (_scanCount % _scanAdFrequency != 0) {
        logger.d('[AdManager] Scan frequency not met, skipping ad');
        return;
      }
    } else if (type == 'video') {
      _videoCount++;
      logger.d('[AdManager] Video count: $_videoCount');

      // 指定回数に達したら広告を表示
      if (_videoCount % _videoAdFrequency != 0) {
        logger.d('[AdManager] Video frequency not met, skipping ad');
        return;
      }
    }

    // 広告が準備できていれば表示
    if (_isInterstitialAdReady && _interstitialAd != null) {
      logger.i('[AdManager] Showing interstitial ad');
      await _interstitialAd!.show();
    } else {
      logger.w('[AdManager] Interstitial ad not ready');
      // 広告が読み込まれていなければ再読み込み
      await loadInterstitialAd();
    }
  }

  /// リワード広告の読み込み
  ///
  /// ユーザーが広告を視聴すると報酬（24時間プレミアム機能など）を得られます。
  Future<void> loadRewardedAd() async {
    if (_isRewardedAdReady) {
      logger.d('[AdManager] Rewarded ad already loaded');
      return;
    }

    try {
      await RewardedAd.load(
        adUnitId: AdConfig.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            logger.i('[AdManager] Rewarded ad loaded');
            _rewardedAd = ad;
            _isRewardedAdReady = true;

            // 広告が閉じられたときの処理
            _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                logger.d(
                  '[AdManager] Rewarded ad dismissed, earned reward: $_earnedReward',
                );
                // Completerに報酬を渡して完了
                if (_rewardCompleter != null &&
                    !_rewardCompleter!.isCompleted) {
                  _rewardCompleter!.complete(_earnedReward);
                }
                _earnedReward = null;
                ad.dispose();
                _rewardedAd = null;
                _isRewardedAdReady = false;

                // 次の広告を事前読み込み
                loadRewardedAd();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                logger.e(
                  '[AdManager] Rewarded ad failed to show: ${error.message}',
                  error: error,
                );
                // エラー時はnullを返す
                if (_rewardCompleter != null &&
                    !_rewardCompleter!.isCompleted) {
                  _rewardCompleter!.complete(null);
                }
                _earnedReward = null;
                ad.dispose();
                _rewardedAd = null;
                _isRewardedAdReady = false;

                // 次の広告を事前読み込み
                loadRewardedAd();
              },
            );
          },
          onAdFailedToLoad: (error) {
            logger.e(
              '[AdManager] Rewarded ad failed to load: ${error.message}',
              error: error,
            );
            _isRewardedAdReady = false;
          },
        ),
      );
    } catch (e) {
      logger.e('[AdManager] Exception loading rewarded ad', error: e);
    }
  }

  /// リワード広告の表示
  ///
  /// ユーザーが広告を最後まで視聴した場合、[RewardItem]が返されます。
  /// 視聴をキャンセルした場合や広告が準備できていない場合は、nullが返されます。
  Future<RewardItem?> showRewardedAd() async {
    if (!_isRewardedAdReady || _rewardedAd == null) {
      logger.w('[AdManager] Rewarded ad not ready');
      // 広告が読み込まれていなければ再読み込み
      await loadRewardedAd();
      return null;
    }

    logger.i('[AdManager] Showing rewarded ad');

    // Completerを作成
    _rewardCompleter = Completer<RewardItem?>();
    _earnedReward = null;

    // 広告を表示
    await _rewardedAd!.show(
      onUserEarnedReward: (ad, rewardItem) {
        logger.i(
          '[AdManager] User earned reward: ${rewardItem.amount} ${rewardItem.type}',
        );
        _earnedReward = rewardItem;
      },
    );

    logger.d(
      '[AdManager] Rewarded ad show() completed, waiting for dismiss...',
    );

    // 広告が閉じられるまで待つ（onAdDismissedFullScreenContentで完了）
    final reward = await _rewardCompleter!.future;
    logger.d('[AdManager] Reward received: $reward');

    // 次の広告を読み込む
    _isRewardedAdReady = false;
    loadRewardedAd();

    return reward;
  }

  /// リソースの解放
  ///
  /// アプリ終了時に呼び出すことでメモリリークを防ぎます。
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    logger.d('[AdManager] Disposed');
  }
}
