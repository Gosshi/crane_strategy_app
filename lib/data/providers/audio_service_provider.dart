import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/audio_service.dart';

/// AudioServiceのプロバイダー
final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  // アプリ起動時に効果音をプリロード
  service.preloadSounds();
  return service;
});
