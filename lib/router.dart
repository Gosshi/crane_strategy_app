import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'data/models/strategy.dart';
import 'data/models/product.dart'; // Import
import 'data/models/post.dart'; // Import
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/detail_screen.dart';
import 'presentation/screens/scan_screen.dart';
import 'presentation/screens/scan_result_screen.dart';
import 'presentation/screens/product_registration_screen.dart';
import 'presentation/screens/product_edit_screen.dart'; // Import
import 'presentation/screens/post_edit_screen.dart'; // Import
import 'presentation/screens/collection_screen.dart';
import 'presentation/screens/account_screen.dart';
import 'presentation/screens/glossary_screen.dart';
import 'presentation/screens/term_detail_screen.dart';

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
    ),
    GoRoute(
      path: '/scan_result',
      name: 'scan_result',
      builder: (context, state) {
        final barcode = state.extra as String;
        return ScanResultScreen(barcode: barcode);
      },
    ),
    GoRoute(
      path: '/product_register',
      name: 'product_register',
      builder: (context, state) {
        String barcode;
        String? initialName;
        String? initialImageUrl;

        if (state.extra is String) {
          barcode = state.extra as String;
        } else if (state.extra is Map<String, dynamic>) {
          final extra = state.extra as Map<String, dynamic>;
          barcode = extra['barcode'] as String;
          initialName = extra['initialName'] as String?;
          initialImageUrl = extra['initialImageUrl'] as String?;
        } else {
          // fallback
          barcode = '';
        }

        return ProductRegistrationScreen(
          barcode: barcode,
          initialName: initialName,
          initialImageUrl: initialImageUrl,
        );
      },
    ),
    GoRoute(
      path: '/collection',
      name: 'collection',
      builder: (context, state) => const CollectionScreen(),
    ),
    GoRoute(
      path: '/product_edit',
      name: 'product_edit',
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductEditScreen(product: product);
      },
    ),
    GoRoute(
      path: '/account',
      name: 'account',
      builder: (context, state) => const AccountScreen(),
    ),
    GoRoute(
      path: '/post_edit',
      name: 'post_edit',
      builder: (context, state) {
        final post = state.extra as Post;
        return PostEditScreen(post: post);
      },
    ),
    GoRoute(
      path: '/glossary',
      name: 'glossary',
      builder: (context, state) => const GlossaryScreen(),
    ),
    GoRoute(
      path: '/term/:id',
      name: 'term_detail',
      builder: (context, state) {
        final termId = state.pathParameters['id']!;
        return TermDetailScreen(termId: termId);
      },
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
