import 'package:equatable/equatable.dart';

class ReportState extends Equatable {
  final int total;
  final int done;
  final int inProgress;
  final int blocked;
  final int overdue;
  final double completion;

  /// ✅ REQUIRED FOR "Open tasks by assignee"
  final Map<String, int> openByAssignee;

  const ReportState({
    required this.total,
    required this.done,
    required this.inProgress,
    required this.blocked,
    required this.overdue,
    required this.completion,
    required this.openByAssignee,
  });

  @override
  List<Object?> get props => [
    total,
    done,
    inProgress,
    blocked,
    overdue,
    completion,
    openByAssignee,
  ];
}
