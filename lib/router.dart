import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'data/models/strategy.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/detail_screen.dart';
import 'presentation/screens/scan_screen.dart';
import 'presentation/screens/scan_result_screen.dart';
import 'presentation/screens/product_registration_screen.dart';
import 'presentation/screens/collection_screen.dart';
import 'presentation/screens/account_screen.dart';

/// GoRouter の設定
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/detail',
      name: 'detail',
      builder: (context, state) {
        final strategy = state.extra as Strategy;
        return DetailScreen(strategy: strategy);
      },
    ),
    GoRoute(
      path: '/scan',
      name: 'scan',
      builder: (context, state) => const ScanScreen(),
      routes: [
        GoRoute(
          path: 'result',
          name: 'scan_result',
          builder: (context, state) {
            final barcode = state.extra as String;
            return ScanResultScreen(barcode: barcode);
          },
        ),
        GoRoute(
          path: 'register',
          name: 'product_register',
          builder: (context, state) {
            final barcode = state.extra as String;
            return ProductRegistrationScreen(barcode: barcode);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/collection',
      name: 'collection',
      builder: (context, state) => const CollectionScreen(),
    ),
    GoRoute(
      path: '/account',
      name: 'account',
      builder: (context, state) => const AccountScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('エラー')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text('ページが見つかりません', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () => context.go('/'),
            child: const Text('ホームに戻る'),
          ),
        ],
      ),
    ),
  ),
);
