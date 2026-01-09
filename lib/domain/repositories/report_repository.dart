import '../../presentation/blocs/report/report_state.dart';

abstract class ReportRepository {
  Future<ReportState> projectStatus(String projectId);
}
