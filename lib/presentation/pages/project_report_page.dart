import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../presentation/blocs/report/report_bloc.dart';
import '../../presentation/blocs/report/report_event.dart';
import '../../presentation/blocs/report/report_state.dart';

class ProjectReportPage extends StatefulWidget {
  final String projectId;
  const ProjectReportPage({super.key, required this.projectId});

  @override
  State<ProjectReportPage> createState() => _ProjectReportPageState();
}

class _ProjectReportPageState extends State<ProjectReportPage> {
  @override
  void initState() {
    super.initState();
    // Load report ONCE
    context.read<ReportBloc>().add(
      LoadReport(widget.projectId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Report'),
      ),
      body: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------- STATUS TILES --------
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 1.4,
                  children: [
                    _tile('Total', state.total),
                    _tile('Done', state.done),
                    _tile('In Progress', state.inProgress),
                    _tile('Blocked', state.blocked),
                    _tile('Overdue', state.overdue),
                    _tile(
                      'Completion %',
                      state.completion.toStringAsFixed(1),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                // -------- OPEN TASKS BY ASSIGNEE --------
                Text(
                  'Open Tasks by Assignee',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8.h),

                if (state.openByAssignee.isEmpty)
                  const Text('No open tasks')
                else
                  Card(
                    child: Column(
                      children: state.openByAssignee.entries.map((entry) {
                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(entry.key),
                          trailing: Text(
                            entry.value.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _tile(String title, Object value) {
    return Card(
      elevation: 2,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
