import 'package:cloud_firestore/cloud_firestore.dart';
import 'report_repository.dart';
import '../models/report.dart';

class FirestoreReportRepository implements ReportRepository {
  final FirebaseFirestore _firestore;

  FirestoreReportRepository(this._firestore);

  @override
  Future<void> addReport(Report report) async {
    await _firestore.collection('reports').doc(report.id).set(report.toMap());
  }
}
