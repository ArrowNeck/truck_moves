import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:truck_moves/providers/job_provider.dart';
import 'package:truck_moves/services/job_service.dart';
import 'package:truck_moves/shared_widgets/network_error_bottom_sheet.dart';
import 'package:truck_moves/shared_widgets/page_loaders.dart';
import 'package:truck_moves/ui/mp/home/job_card.dart';

class FutureJobs extends StatefulWidget {
  const FutureJobs({super.key});

  @override
  State<FutureJobs> createState() => _FutureJobsState();
}

class _FutureJobsState extends State<FutureJobs> {
  int skip = 0;
  bool allLoad = false;
  bool inLoading = false;
  late ScrollController scrollController;
  @override
  void initState() {
    context.read<JobProvider>().futureJobs = null;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getFutureJobs();
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
      _getFutureJobs();
    }
  }

  _getFutureJobs() async {
    PageLoader.showLoader(context);
    inLoading = true;
    final res = await JobService.futureJobsHeader(skip: skip);
    if (mounted) Navigator.pop(context);
    inLoading = false;
    res.when(success: (data) {
      if (data.length < 7) {
        allLoad = true;
      }
      context.read<JobProvider>().setFutureJobs(data);
    }, failure: (error) {
      showErrorSheet(
        context: context,
        exception: error,
        onTap: () {
          _getFutureJobs();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final futureJobs = context.watch<JobProvider>().futureJobs;
    return ListView.builder(
        controller: scrollController,
        itemCount: futureJobs?.length ?? 1,
        itemBuilder: (context, index) {
          return futureJobs == null
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
              : JobCard(job: futureJobs[index]);
        });
  }
}
