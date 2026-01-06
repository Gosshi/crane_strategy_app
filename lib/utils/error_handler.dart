import 'dart:async';
import 'package:flutter/material.dart';

/// エラーの種類
enum AppErrorType { network, timeout, permission, notFound, unknown }

/// アプリ固有のエラークラス
class AppError implements Exception {
  final String message;
  final AppErrorType type;
  final Object? originalError;

  const AppError({
    required this.message,
    required this.type,
    this.originalError,
  });

  @override
  String toString() => message;

  /// ユーザー向けのメッセージを取得
  String get userMessage {
    switch (type) {
      case AppErrorType.network:
        return 'ネットワーク接続を確認してください';
      case AppErrorType.timeout:
        return '接続がタイムアウトしました。再度お試しください';
      case AppErrorType.permission:
        return 'この操作を行う権限がありません';
      case AppErrorType.notFound:
        return 'データが見つかりませんでした';
      case AppErrorType.unknown:
        return '予期しないエラーが発生しました';
    }
  }

  /// エラー用のアイコンを取得
  IconData get icon {
    switch (type) {
      case AppErrorType.network:
        return Icons.wifi_off;
      case AppErrorType.timeout:
        return Icons.timer_off;
      case AppErrorType.permission:
        return Icons.lock;
      case AppErrorType.notFound:
        return Icons.search_off;
      case AppErrorType.unknown:
        return Icons.error_outline;
    }
  }
}

/// 共通エラーハンドラー
class ErrorHandler {
  /// リトライ付きでFuture処理を実行
  static Future<T> withRetry<T>({
    required Future<T> Function() action,
    int maxAttempts = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        return await action();
      } catch (e) {
        if (attempt == maxAttempts) {
          rethrow;
        }
        await Future.delayed(delay * attempt); // 指数バックオフ
      }
    }
    throw AppError(message: 'リトライ回数の上限に達しました', type: AppErrorType.unknown);
  }

  /// タイムアウト付きでFuture処理を実行
  static Future<T> withTimeout<T>({
    required Future<T> Function() action,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    try {
      return await action().timeout(timeout);
    } on TimeoutException {
      throw AppError(message: '処理がタイムアウトしました', type: AppErrorType.timeout);
    }
  }

  /// 一般的なエラーをAppErrorに変換
  static AppError toAppError(Object error) {
    if (error is AppError) return error;

    final errorString = error.toString().toLowerCase();

    if (errorString.contains('socket') ||
        errorString.contains('network') ||
        errorString.contains('connection')) {
      return AppError(
        message: 'ネットワークエラー',
        type: AppErrorType.network,
        originalError: error,
      );
    }

    if (errorString.contains('timeout')) {
      return AppError(
        message: 'タイムアウト',
        type: AppErrorType.timeout,
        originalError: error,
      );
    }

    if (errorString.contains('permission') || errorString.contains('denied')) {
      return AppError(
        message: '権限エラー',
        type: AppErrorType.permission,
        originalError: error,
      );
    }

    if (errorString.contains('not found') ||
        errorString.contains('not exist')) {
      return AppError(
        message: 'データなし',
        type: AppErrorType.notFound,
        originalError: error,
      );
    }

    return AppError(
      message: error.toString(),
      type: AppErrorType.unknown,
      originalError: error,
    );
  }

  /// SnackBarでエラーメッセージを表示
  static void showError(BuildContext context, Object error) {
    final appError = toAppError(error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(appError.icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(appError.userMessage)),
          ],
        ),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: '閉じる',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
