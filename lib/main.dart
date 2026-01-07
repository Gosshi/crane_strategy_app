import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'firebase_options.dart';
import 'router.dart';
import 'theme/app_theme.dart';
import 'services/ad_manager.dart';
import 'data/providers/auth_provider.dart';

import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Google Sign-In (v7+) 必須の初期化
  // 必要であれば clientId などをここで渡す
  try {
    await GoogleSignIn.instance.initialize();
  } catch (e) {
    debugPrint('GoogleSignIn initialize error (ignored): $e');
  }

  // AdMob初期化
  try {
    await AdManager().initialize();
  } catch (e) {
    debugPrint('AdManager initialize error (ignored): $e');
  }

  runApp(const ProviderScope(child: CraneStrategyApp()));
}

/// クレーンゲーム攻略アプリ
class CraneStrategyApp extends ConsumerStatefulWidget {
  const CraneStrategyApp({super.key});

  @override
  ConsumerState<CraneStrategyApp> createState() => _CraneStrategyAppState();
}

class _CraneStrategyAppState extends ConsumerState<CraneStrategyApp> {
  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    // 匿名ログインを実行
    // すでにログイン済みの場合は何もしない等の制御はRepository側でやっても良いが
    // ここでは単純に signInAnonymously を呼ぶ (Firebase側で既存ユーザーなら維持される)
    try {
      final repo = ref.read(authRepositoryProvider);
      if (repo.currentUser == null) {
        await repo.signInAnonymously();
      }
    } catch (e) {
      debugPrint('Auth initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Crenavi',
      debugShowCheckedModeBanner: false,
      // 多言語設定
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja'), // 日本語
        Locale('en'), // 英語
        Locale('zh'), // 簡体中文
        Locale('zh', 'TW'), // 繁体中文
        Locale('ko'), // 韓国語
      ],
      // デバイスの言語設定に従う（明示的なlocaleは削除）
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
