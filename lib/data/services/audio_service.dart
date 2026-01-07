import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// 効果音を管理するサービスクラス
class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;
  bool _soundEnabled = true;

  /// 効果音のプリロード
  Future<void> preloadSounds() async {
    if (_isInitialized) return;

    try {
      // AssetSourceでプリロード
      await _audioPlayer.setSource(AssetSource('sounds/scan_success.mp3'));
      await _audioPlayer.setSource(
        AssetSource('sounds/acquisition_success.mp3'),
      );
      _isInitialized = true;
    } catch (e) {
      // プリロード失敗時はログ出力のみ（ユーザー体験には影響させない）
      debugPrint('Failed to preload sounds: $e');
    }
  }

  /// スキャン成功時の効果音を再生
  Future<void> playScanSuccess() async {
    if (!_soundEnabled) return;

    try {
      await _audioPlayer.play(AssetSource('sounds/scan_success.mp3'));
    } catch (e) {
      debugPrint('Failed to play scan success sound: $e');
    }
  }

  /// 獲得登録成功時の効果音を再生
  Future<void> playAcquisitionSuccess() async {
    if (!_soundEnabled) return;

    try {
      await _audioPlayer.play(AssetSource('sounds/acquisition_success.mp3'));
    } catch (e) {
      debugPrint('Failed to play acquisition success sound: $e');
    }
  }

  /// 効果音の有効/無効を設定
  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  /// 効果音が有効かどうかを取得
  bool get isSoundEnabled => _soundEnabled;

  /// リソースの解放
  void dispose() {
    _audioPlayer.dispose();
  }
}
