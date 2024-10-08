import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truck_moves/providers/job_provider.dart';
import 'package:truck_moves/services/job_service.dart';
import 'package:truck_moves/shared_widgets/network_error_bottom_sheet.dart';
import 'package:truck_moves/shared_widgets/no_data.dart';
import 'package:truck_moves/shared_widgets/page_loaders.dart';
import 'package:truck_moves/ui/mp/home/job_card.dart';

class CurrentJobs extends StatefulWidget {
  const CurrentJobs({super.key});

  @override
  State<CurrentJobs> createState() => _CurrentJobsState();
}

class _CurrentJobsState extends State<CurrentJobs> {
  int skip = 0;
  bool allLoad = false;
  bool inLoading = false;
  late ScrollController scrollController;
  @override
  void initState() {
    context.read<JobProvider>().currentJobs.clear();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getCurrentJobs();
    });
    scrollController = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (!allLoad && !inLoading && scrollController.position.extentAfter == 0) {
      skip += 7;
      _getCurrentJobs();
    }
  }

  _getCurrentJobs() async {
    PageLoader.showLoader(context);
    inLoading = true;
    final res = await JobService.currentJobsHeader(skip: skip);
    if (mounted) Navigator.pop(context);
    inLoading = false;
    res.when(success: (data) {
      if (data.length < 7) {
        allLoad = true;
      }
      context.read<JobProvider>().setCurrentJobs(data);
    }, failure: (error) {
      showErrorSheet(
        context: context,
        exception: error,
        onTap: () {
          _getCurrentJobs();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentJobs = context.watch<JobProvider>().currentJobs;
    return currentJobs.isEmpty
        ? const NoData(
            label: "There are no jobs assigned to you",
          )
        : ListView.builder(
            controller: scrollController,
            itemCount: currentJobs.length,
            itemBuilder: (context, index) {
              return JobCard(job: currentJobs[index]);
            });
  }
}
