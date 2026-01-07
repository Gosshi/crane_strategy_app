import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/premium_service.dart';

/// PremiumServiceのプロバイダー
final premiumServiceProvider = Provider((ref) => PremiumService());

/// プレミアムユーザー判定のプロバイダー
///
/// リワード広告での24時間解放、またはサブスクリプション状態（Phase 2）をチェック
final isPremiumProvider = FutureProvider((ref) async {
  final service = ref.watch(premiumServiceProvider);
  return service.isPremium();
});

/// プレミアム解放の残り時間プロバイダー（デバッグ用）
final remainingPremiumTimeProvider = FutureProvider((ref) async {
  final service = ref.watch(premiumServiceProvider);
  return service.getRemainingPremiumTime();
});
