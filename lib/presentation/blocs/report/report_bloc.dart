import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/report_repository.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<LoadReport, ReportState> {
  final ReportRepository repository;

  ReportBloc(this.repository)
      : super(const ReportState(
    total: 0,
    done: 0,
    inProgress: 0,
    blocked: 0,
    overdue: 0,
    completion: 0, openByAssignee: {},
  )) {
    on<LoadReport>(_onLoad);
  }

  Future<void> _onLoad(
      LoadReport event,
      Emitter<ReportState> emit,
      ) async {
    final report = await repository.projectStatus(event.projectId);
    emit(report);
  }
}
