import 'report_repository.dart';
import '../models/report.dart';

class MockReportRepository implements ReportRepository {
  final List<Report> _reports = [];

  @override
  Future<void> addReport(Report report) async {
    _reports.add(report);
  }
}
