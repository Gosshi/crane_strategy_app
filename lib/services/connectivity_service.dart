import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ネットワーク接続状態を監視するサービス
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// 接続状態の変化をStreamで監視
  Stream<bool> get isConnectedStream {
    return _connectivity.onConnectivityChanged.map((results) {
      // connectivity_plus 6.x uses List<ConnectivityResult>
      return results.isNotEmpty && !results.contains(ConnectivityResult.none);
    });
  }

  /// 現在の接続状態を確認
  Future<bool> checkConnection() async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty && !results.contains(ConnectivityResult.none);
  }
}

/// ConnectivityServiceのプロバイダー
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

/// 接続状態をStreamで監視するプロバイダー
final connectivityStreamProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.isConnectedStream;
});
