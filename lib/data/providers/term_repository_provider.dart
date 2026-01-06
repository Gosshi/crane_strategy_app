import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/term_repository.dart';

/// TermRepositoryのプロバイダー
final termRepositoryProvider = Provider<TermRepository>((ref) {
  return TermRepository();
});
