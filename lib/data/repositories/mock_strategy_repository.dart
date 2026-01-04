import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/strategy.dart';

/// ダミーデータを返すリポジトリ
class MockStrategyRepository {
  /// ダミーの攻略法データを返す
  Future<List<Strategy>> fetchStrategies() async {
    // 実際のAPIコールをシミュレートするために少し遅延を追加
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      const Strategy(
        id: '1',
        title: '橋渡し・基本の縦ハメ',
        settingType: '橋渡し',
        thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
        videoId: 'dQw4w9WgXcQ',
      ),
      const Strategy(
        id: '2',
        title: '橋渡し・横ハメのコツ',
        settingType: '橋渡し',
        thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/hqdefault.jpg',
        videoId: 'dQw4w9WgXcQ',
      ),
      const Strategy(
        id: '3',
        title: '3本爪・初期位置からの攻略',
        settingType: '3本爪',
        thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/mqdefault.jpg',
        videoId: 'dQw4w9WgXcQ',
      ),
    ];
  }
}

/// リポジトリのプロバイダー
final mockStrategyRepositoryProvider = Provider<MockStrategyRepository>((ref) {
  return MockStrategyRepository();
});

/// 攻略法リストの FutureProvider
final strategiesProvider = FutureProvider<List<Strategy>>((ref) async {
  final repository = ref.watch(mockStrategyRepositoryProvider);
  return repository.fetchStrategies();
});
