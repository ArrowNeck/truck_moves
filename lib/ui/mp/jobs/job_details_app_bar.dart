import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:truck_moves/constant.dart';
import 'package:truck_moves/models/job.dart';
import 'package:truck_moves/providers/job_provider.dart';
import 'package:truck_moves/services/job_service.dart';
import 'package:truck_moves/shared_widgets/confirmation_popup.dart';
import 'package:truck_moves/shared_widgets/network_error_bottom_sheet.dart';
import 'package:truck_moves/shared_widgets/page_loaders.dart';
import 'package:truck_moves/shared_widgets/toast_bottom_sheet.dart';
import 'package:truck_moves/ui/mp/jobs/add_purchase.dart';
import 'package:truck_moves/ui/mp/jobs/pre_departure_checklist.dart';
import 'package:truck_moves/ui/mp/jobs/trailer_pick_drop_sheet.dart';
import 'package:truck_moves/utils/hero_dialog_route.dart';
import 'package:truck_moves/utils/location_utils.dart';

class JobDetailsAppBar extends StatefulWidget implements PreferredSizeWidget {
  const JobDetailsAppBar({super.key});

  @override
  State<JobDetailsAppBar> createState() => _JobDetailsAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _JobDetailsAppBarState extends State<JobDetailsAppBar> {
  @override
  Widget build(BuildContext context) {
    Job job = context.watch<JobProvider>().currentlyRunningJob!;
    return AppBar(
      backgroundColor: job.status == 8 ? Colors.redAccent : bgColor,
      centerTitle: false,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      elevation: 0,
      title: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            job.id.toString(),
            style: TextStyle(
              fontSize: 23.sp,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      actions: [
        if (job.status < 9 && job.status > 4 && job.trailers.isNotEmpty)
          IconButton(
            onPressed: () {
              showTrailerPickDropSheet(context: context);
            },
            visualDensity: VisualDensity.compact,
            icon: SvgPicture.asset(
              "assets/icons/trailer-pick.svg",
              width: 22.5.h,
              height: 22.5.h,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        IconButton(
          onPressed: () {
            Navigator.push(
                context, HeroDialogRoute(builder: (_) => const AddPurchase()));
          },
          visualDensity: VisualDensity.compact,
          icon: SvgPicture.asset(
            "assets/icons/purchase.svg",
            width: 22.5.h,
            height: 22.5.h,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PreDepartureChecklistPage(
                  jobId: job.id,
                  preChecklist: job.preDepartureChecklist,
                ),
              ),
            );
          },
          visualDensity: VisualDensity.compact,
          icon: SvgPicture.asset(
            "assets/icons/checklist-${job.status < 5 ? "edit" : "done"}.svg",
            width: 22.5.h,
            height: 22.5.h,
            colorFilter: ColorFilter.mode(
                job.status < 5 ? Colors.white : const Color(0xFFC0C0C0),
                BlendMode.srcIn),
          ),
        ),
        if (!(job.status == 9))
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  HeroDialogRoute(
                    builder: (_) => ConfirmationPopup(
                      title: job.status == 8
                          ? "Breakdown/Delay Resolved"
                          : "Breakdown/Delay",
                      message: job.status == 8
                          ? 'Has the breakdown/delay been resolved? Please tap the "Start" button after the popup to continueyour journey.'
                          : "Report a breakdown or delay?",
                      leftBtnText: "No",
                      rightBtnText: "Yes",
                      rightBtnColor: job.status == 6 ? Colors.redAccent : null,
                      onRightTap: _breakDownOrDelay,
                    ),
                  ));
            },
            visualDensity: VisualDensity.compact,
            icon: SvgPicture.asset(
              "assets/icons/delay.svg",
              width: 22.5.h,
              height: 22.5.h,
              colorFilter: ColorFilter.mode(
                  job.status == 8 ? Colors.black : Colors.white,
                  BlendMode.srcIn),
            ),
          ),
      ],
    );
  }

  _breakDownOrDelay() async {
    final jobProvider = context.read<JobProvider>();
    String? location;
    int jobId = jobProvider.currentlyRunningJob!.id;
    int? legId;
    if (jobProvider.currentlyRunningJob!.status == 6) {
      try {
        legId = jobProvider.currentlyRunningJob!.legs.last.id;
        PageLoader.showLoader(context);
        location = await LocationUtils.getCurrentLocation();
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          Navigator.pop(context);
          showToastSheet(
            context: context,
            title: "Error!",
            message: e.toString(),
            isError: true,
          );
        }
        return;
      }
    }

    if (!mounted) return;
    PageLoader.showLoader(context);
    final res = jobProvider.currentlyRunningJob!.status != 8
        ? await JobService.reportDelay(
            jobId: jobId,
            legId: legId,
            endLocation: location,
          )
        : await JobService.resolveDelay(jobId: jobId);
    if (!mounted) return;
    Navigator.pop(context);
    res.when(success: (data) {
      jobProvider.breakdownStatus(
        jobProvider.currentlyRunningJob!.status != 8,
        endLocation: location,
      );
    }, failure: (error) {
      showErrorSheet(
        context: context,
        exception: error,
      );
    });
  }
}
