import '../models/report.dart';

abstract class ReportRepository {
  Future<void> addReport(Report report);
}
