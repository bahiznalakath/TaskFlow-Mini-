import 'package:equatable/equatable.dart';

class LoadReport extends Equatable {
  final String projectId;
  const LoadReport(this.projectId);

  @override
  List<Object?> get props => [projectId];
}
