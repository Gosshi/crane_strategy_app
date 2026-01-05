import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// バーコードスキャン画面
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  late MobileScannerController _controller;
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      // リアカメラを使用
      facing: CameraFacing.back,
      // フラッシュオフ
      torchEnabled: false,
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        // バックグラウンド時はカメラを停止すべきだが、MobileScannerは自動制御される場合もある
        // 必要に応じて _controller.stop() などを呼ぶ
        break;
      case AppLifecycleState.resumed:
        if (_controller.value.isInitialized) {
          _controller.start();
        }
        break;
      case AppLifecycleState.inactive:
        break;
    }
  }

  /// スキャン完了時の処理
  void _onDetect(BarcodeCapture capture) {
    if (!_isScanning) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        _handleBarcodeFound(barcode.rawValue!);
        break; // 最初のひとつだけ処理
      }
    }
  }

  /// バーコードが見つかったときの共通処理
  void _handleBarcodeFound(String code) {
    setState(() {
      _isScanning = false;
    });

    // 念のためカメラ停止（遷移後の負荷軽減）
    _controller.stop();

    // 結果画面へ遷移 (GoRouter)
    // context.go('/scan/result?code=$code') のようにパスパラメータを使用
    // ここではパス構成が決まっていないため、Router定義後に合わせるが、
    // 一般的に /scan/result/:code または query parameter で渡す
    context.push('/scan_result', extra: code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // カメラプレビュー
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error, color: Colors.white, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'カメラエラー: ${error.errorCode}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),

          // スキャン枠（オーバーレイ）
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Align(
                alignment: Alignment.center,
                child: Divider(color: Colors.red, thickness: 1), // 読み取りライン
              ),
            ),
          ),

          // 閉じるボタン
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
            ),
          ),

          // デバッグ用（シミュレータ用）ボタン
          // カメラが利用できない環境や、手軽にテストしたい場合のために表示
          if (kDebugMode)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  const Text(
                    'Debug Actions',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            _handleBarcodeFound('4901234567890'), // 登録済み商品
                        child: const Text('Found(490...)'),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            _handleBarcodeFound('0000000000000'), // 未登録
                        child: const Text('Not Found'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
