import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// アプリ全体で使用するカスタムロガー
///
/// Debug mode: 全てのログレベル（Debug, Info, Warning, Error）を出力
/// Release mode: Error レベルのみ出力してパフォーマンスへの影響を最小化
final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0, // スタックトレースの行数（0=非表示）
    errorMethodCount: 5, // エラー時のスタックトレース行数
    lineLength: 80, // 1行あたりの文字数
    colors: true, // ターミナルで色付け
    printEmojis: true, // 絵文字を表示
    dateTimeFormat: DateTimeFormat.none, // 時刻は非表示（Flutter Devtoolsで確認可能）
  ),
  level: kReleaseMode ? Level.error : Level.debug,
);

/// ログレベルの使い分け:
/// - logger.d('メッセージ') : Debug - 開発時のデバッグ情報
/// - logger.i('メッセージ') : Info - 通常の情報ログ（データ取得成功など）
/// - logger.w('メッセージ') : Warning - 警告（非推奨メソッドの使用など）
/// - logger.e('メッセージ', error: e, stackTrace: st) : Error - エラー情報
