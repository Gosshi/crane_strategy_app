import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

/// プレミアム機能管理サービス
///
/// リワード広告視聴後の24時間プレミアム機能解放を管理します。
/// Phase 2でサブスクリプション状態のチェックも追加予定です。
class PremiumService {
  static const _key = 'premium_unlock_until';

  /// プレミアムユーザーかチェック
  ///
  /// リワード広告で24時間解放されているか、
  /// またはサブスクリプション契約中（Phase 2で実装予定）かを確認
  Future<bool> isPremium() async {
    // リワード広告での24時間解放をチェック
    final unlockUntil = await _getUnlockUntil();
    if (unlockUntil != null && DateTime.now().isBefore(unlockUntil)) {
      logger.d('[PremiumService] Premium unlocked until: $unlockUntil');
      return true;
    }

    // TODO: Phase 2でサブスクリプション状態もチェック
    // final isSubscribed = await RevenueCat.isPremium();
    // return isSubscribed;

    return false;
  }

  /// リワード広告視聴後に24時間プレミアム機能を解放
  Future<void> unlockPremiumFor24Hours() async {
    final unlockUntil = DateTime.now().add(const Duration(hours: 24));
    await _saveUnlockUntil(unlockUntil);
    logger.i(
      '[PremiumService] Premium unlocked for 24 hours until: $unlockUntil',
    );
  }

  /// プレミアム解放の残り時間を取得（デバッグ用）
  Future<Duration?> getRemainingPremiumTime() async {
    final unlockUntil = await _getUnlockUntil();
    if (unlockUntil != null && DateTime.now().isBefore(unlockUntil)) {
      return unlockUntil.difference(DateTime.now());
    }
    return null;
  }

  /// SharedPreferencesから期限を取得
  Future<DateTime?> _getUnlockUntil() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getString(_key);
      if (timestamp != null) {
        return DateTime.parse(timestamp);
      }
    } catch (e) {
      logger.e('[PremiumService] Error getting unlock time', error: e);
    }
    return null;
  }

  /// SharedPreferencesに期限を保存
  Future<void> _saveUnlockUntil(DateTime unlockUntil) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, unlockUntil.toIso8601String());
    } catch (e) {
      logger.e('[PremiumService] Error saving unlock time', error: e);
    }
  }

  /// プレミアム解放をクリア（デバッグ用）
  Future<void> clearPremiumUnlock() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
      logger.i('[PremiumService] Premium unlock cleared');
    } catch (e) {
      logger.e('[PremiumService] Error clearing unlock', error: e);
    }
  }
}
