import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:truck_moves/constant.dart';
import 'package:truck_moves/models/job.dart';
import 'package:truck_moves/providers/job_provider.dart';
import 'package:truck_moves/services/job_service.dart';
import 'package:truck_moves/shared_widgets/confirmation_popup.dart';
import 'package:truck_moves/shared_widgets/job_stop_bottom_sheet.dart';
import 'package:truck_moves/shared_widgets/network_error_bottom_sheet.dart';
import 'package:truck_moves/shared_widgets/page_loaders.dart';
import 'package:truck_moves/shared_widgets/toast_bottom_sheet.dart';
import 'package:truck_moves/ui/mp/home/home_page.dart';
import 'package:truck_moves/ui/mp/jobs/pre_departure_checklist.dart';
import 'package:truck_moves/utils/extensions.dart';
import 'package:truck_moves/utils/hero_dialog_route.dart';
import 'package:truck_moves/utils/location_utils.dart';

class BottomButton extends StatefulWidget {
  const BottomButton({super.key});

  @override
  State<BottomButton> createState() => _BottomButtonState();
}

class _BottomButtonState extends State<BottomButton> {
  _createLeg() async {
    try {
      PageLoader.showLoader(context);
      String location = await LocationUtils.getCurrentLocation();
      if (!mounted) return;

      final res = await JobService.createLeg(
          jobId: context.read<JobProvider>().currentlyRunningJob!.id,
          location: location);
      if (mounted) Navigator.pop(context);

      res.when(success: (data) {
        context.read<JobProvider>().addLeg(data: data);
        showToastSheet(
            context: context,
            title: "All Set to Drive!",
            icon: "ready",
            message:
                "Your job has been successfully initiated, and you are now ready to begin driving.",
            onTap: () {
              if (context.read<JobProvider>().previousStatus == 15) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                  (route) => false,
                );
              }
            });
      }, failure: (error) {
        showErrorSheet(
          context: context,
          exception: error,
        );
      });
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
    }
  }

  _closeLeg({required int selectedJobStatus}) async {
    try {
      PageLoader.showLoader(context);
      String location = await LocationUtils.getCurrentLocation();
      if (!mounted) return;

      final res = await JobService.closeLeg(
        leg: context.read<JobProvider>().currentlyRunningJob!.legs.last,
        location: location,
        jobStatus: selectedJobStatus,
      );
      if (mounted) Navigator.pop(context);

      res.when(success: (data) {
        context
            .read<JobProvider>()
            .updateLeg(endLocation: location, jobStatus: selectedJobStatus);
        showToastSheet(
          context: context,
          title: "Stopped Driving!",
          icon: selectedJobStatus.iconName,
          message:
              "You have successfully stopped ${selectedJobStatus.message}.",
          onTap: () {
            if (selectedJobStatus == 15) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
                (route) => false,
              );
            }
          },
        );
      }, failure: (error) {
        showErrorSheet(
          context: context,
          exception: error,
        );
      });
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
    }
  }

  @override
  Widget build(BuildContext context) {
    Job job = context.watch<JobProvider>().currentlyRunningJob!;
    if (job.status == 8) {
      return const SizedBox.shrink();
    }
    return GestureDetector(
      onTap: () {
        if (job.status == 6) {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            isDismissible: true,
            context: context,
            builder: (context) => const JobStopBottomSheet(),
          ).then((jobStatus) {
            if (jobStatus != null) {
              _closeLeg(selectedJobStatus: jobStatus);
            }
          });
        } else if (job.status == 9) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PreDepartureChecklistPage(
                jobId: job.id,
                isArrival: true,
              ),
            ),
          );
        } else {
          if (job.preDepartureChecklist == null) {
            Navigator.push(
              context,
              HeroDialogRoute(
                builder: (_) => ConfirmationPopup(
                  title: "Prechecking",
                  message:
                      "Before you depart you must complete the pre-departure checklist. Tap continue to begin.",
                  leftBtnText: "Cancel",
                  rightBtnText: "Continue",
                  onRightTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PreDepartureChecklistPage(jobId: job.id),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              HeroDialogRoute(
                builder: (_) => ConfirmationPopup(
                  title: "Acknowledgement",
                  message:
                      "I acknowledge that I am not under the influence of drugs or alcohol and am fit to drive.",
                  leftBtnText: "Cancel",
                  rightBtnText: "Agreed",
                  onRightTap: _createLeg,
                ),
              ),
            );
          }
        }
      },
      child: Container(
        height: 80.h,
        padding: EdgeInsets.symmetric(vertical: 20.h),
        color: job.status == 6
            ? Colors.redAccent
            : job.status == 9
                ? primaryColor
                : Colors.green,
        child: Text(
          (job.status == 6
                  ? "Stop"
                  : job.status == 9
                      ? "Next"
                      : 'Start')
              .toUpperCase(),
          style: TextStyle(
            color: job.status == 9 ? Colors.black : Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
