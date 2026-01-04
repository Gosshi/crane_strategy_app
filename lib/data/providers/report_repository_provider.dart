import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/report_repository.dart';
import '../repositories/firestore_report_repository.dart';
import '../repositories/mock_report_repository.dart';

// フラグで切り替え可能にする
const bool useFirestoreForReport = true;

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  if (useFirestoreForReport) {
    return FirestoreReportRepository(FirebaseFirestore.instance);
  } else {
    return MockReportRepository();
  }
});
