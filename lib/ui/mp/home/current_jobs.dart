import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:truck_moves/providers/job_provider.dart';
import 'package:truck_moves/services/job_service.dart';
import 'package:truck_moves/shared_widgets/network_error_bottom_sheet.dart';
import 'package:truck_moves/shared_widgets/page_loaders.dart';
import 'package:truck_moves/ui/mp/home/job_header_card.dart';

class CurrentJobs extends StatefulWidget {
  const CurrentJobs({super.key});

  @override
  State<CurrentJobs> createState() => _CurrentJobsState();
}

class _CurrentJobsState extends State<CurrentJobs> {
  int skip = 0;
  bool allLoad = false;
  late ScrollController scrollController;
  @override
  void initState() {
    context.read<JobProvider>().currentJobs = null;
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
    if (!allLoad && scrollController.position.extentAfter == 0) {
      skip += 7;
      _getCurrentJobs();
    }
  }

  _getCurrentJobs() async {
    PageLoader.showLoader(context);
    final res = await JobService.currentJobsHeader(skip: skip);
    if (mounted) Navigator.pop(context);
    res.when(success: (data) {
      if (data.length < 7) {
        allLoad = true;
      }
      context.read<JobProvider>().setCurrentJobs(data);
    }, failure: (error) {
      ErrorSheet.show(context: context, exception: error);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentJobs = context.watch<JobProvider>().currentJobs;
    return ListView.builder(
        controller: scrollController,
        itemCount: currentJobs?.length ?? 1,
        itemBuilder: (context, index) {
          return currentJobs == null
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 300.h),
                  child: Text(
                    "There are no jobs assigned to you",
                    style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                )
              : JobHeaderCard(job: currentJobs[index]);
        });
  }
}
