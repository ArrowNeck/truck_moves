import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truck_moves/providers/job_provider.dart';
import 'package:truck_moves/services/job_service.dart';
import 'package:truck_moves/shared_widgets/network_error_bottom_sheet.dart';
import 'package:truck_moves/shared_widgets/no_data.dart';
import 'package:truck_moves/shared_widgets/page_loaders.dart';
import 'package:truck_moves/ui/mp/home/job_card.dart';

class StoreJobs extends StatefulWidget {
  const StoreJobs({super.key});

  @override
  State<StoreJobs> createState() => _StoreJobsState();
}

class _StoreJobsState extends State<StoreJobs> {
  int skip = 0;
  bool allLoad = false;
  bool inLoading = false;
  late ScrollController scrollController;
  @override
  void initState() {
    context.read<JobProvider>().storeJobs.clear();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getStoreJobs();
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
      _getStoreJobs();
    }
  }

  _getStoreJobs() async {
    PageLoader.showLoader(context);
    inLoading = true;
    final res = await JobService.storeJobsHeader(skip: skip);
    if (mounted) Navigator.pop(context);
    inLoading = false;
    res.when(success: (data) {
      if (data.length < 7) {
        allLoad = true;
      }
      context.read<JobProvider>().setStoreJobs(data);
    }, failure: (error) {
      showErrorSheet(
        context: context,
        exception: error,
        onTap: () {
          _getStoreJobs();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final storeJobs = context.watch<JobProvider>().storeJobs;
    return storeJobs.isEmpty
        ? const NoData(
            label: "There are no jobs in store",
          )
        : ListView.builder(
            controller: scrollController,
            itemCount: storeJobs.length,
            itemBuilder: (context, index) {
              return JobCard(job: storeJobs[index]);
            });
  }
}
