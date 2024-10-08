import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:truck_moves/constant.dart';
import 'package:truck_moves/models/job.dart';
import 'package:truck_moves/providers/job_provider.dart';
import 'package:truck_moves/services/job_service.dart';
import 'package:truck_moves/shared_widgets/page_loaders.dart';
import 'package:truck_moves/shared_widgets/submit_button.dart';
import 'package:truck_moves/shared_widgets/toast_bottom_sheet.dart';

showTrailerPickDropSheet({required BuildContext context}) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) => const TrailerPickDropSheet());
}

class TrailerPickDropSheet extends StatefulWidget {
  const TrailerPickDropSheet({super.key});

  @override
  State<TrailerPickDropSheet> createState() => _TrailerPickDropSheetState();
}

class _TrailerPickDropSheetState extends State<TrailerPickDropSheet> {
  int? _selectedIndex;
  int _currentlyRunIndex = -1;
  List<Trailer> trailers = [];
  @override
  void initState() {
    trailers = context.read<JobProvider>().currentlyRunningJob?.trailers ?? [];
    _currentlyRunIndex = trailers.indexWhere((e) => e.status == 1);
    if (_currentlyRunIndex > -1) {
      _selectedIndex = _currentlyRunIndex;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 428.w,
      constraints: BoxConstraints(
        maxHeight: 926.h * .925,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.h),
          topRight: Radius.circular(10.h),
        ),
      ),
      child: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Trailers",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF15294B),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 30.h,
                    height: 30.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.h),
                      color: const Color(0xFFF5F6F7),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: const Color(0xFF505F79),
                      size: 25.h,
                    ),
                  ),
                )
              ],
            ),
          ),
          Flexible(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              shrinkWrap: true,
              itemBuilder: (_, index) {
                return _trailerCard(
                  index,
                  trailers[index],
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 5),
              itemCount: trailers.length,
            ),
          ),
          SizedBox(height: 15.h),
          if (_selectedIndex != null)
            SubmitButton(
              onTap: _hookupOrDrop,
              label: _currentlyRunIndex != _selectedIndex ? "Hookup" : "Drop",
              radius: 8,
              color: _currentlyRunIndex != _selectedIndex
                  ? Colors.green
                  : Colors.redAccent,
              labelColor: Colors.white,
            )
        ],
      )),
    );
  }

  _hookupOrDrop() async {
    bool isHookup = _currentlyRunIndex != _selectedIndex;
    PageLoader.showLoader(context);
    final res = await JobService.hookupOrDropTrailer(
      jobId: trailers[_selectedIndex!].jobId,
      trailerId: trailers[_selectedIndex!].id,
      isHookup: isHookup,
    );
    if (!mounted) return;
    Navigator.pop(context);

    res.when(
      success: (data) {
        showToastSheet(
          context: context,
          title: "${isHookup ? "Hookup" : "Drop"} Complete!",
          message: isHookup
              ? "Your trailer is now connected. Drive safely!"
              : "Your trailer has been successfully disconnected.",
          onTap: () => Navigator.pop(context),
        );
        context.read<JobProvider>().updateTrailerStatus(
              id: trailers[_selectedIndex!].id,
              isHookup: isHookup,
            );
      },
      failure: (error) {
        showToastSheet(
          context: context,
          title: "${isHookup ? "Hookup" : "Drop"} Failed!",
          message:
              "Trailer ${isHookup ? "hookup" : "drop"} unsuccessful. Ensure network connection and retry.",
          isError: true,
        );
      },
    );
  }

  _trailerCard(int index, Trailer trailer) {
    return GestureDetector(
      onTap: () {
        if (_currentlyRunIndex == -1 && trailer.status != 2) {
          setState(() {
            _selectedIndex = index;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
          color: trailer.status == 2
              ? const Color(0xFFcccccc)
              : index == _selectedIndex
                  ? primaryColor.withOpacity(0.25)
                  : Colors.transparent,
          border: Border.all(
            color: trailer.status == 2 ? Colors.grey : primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.symmetric(vertical: 10.h),
            title: Row(
              children: [
                Text(
                  "Trailer",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF5DB075),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 16.w,
                ),
                Container(
                  alignment: Alignment.center,
                  height: 22.5.h,
                  width: 22.5.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF5DB075),
                  ),
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            iconColor: const Color(0xFF5DB075),
            collapsedIconColor: const Color(0xFF5DB075),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            dense: true,
            children: [
              _dataItem("Hookup Type",
                  trailer.hookupTypeNavigation.type.replaceAll("_", " "),
                  topPadding: 0),
              _dataItem("Hookup Location", trailer.hookupLocation),
              _dataItem("Dropoff Location", trailer.dropOffLocation),
            ],
          ),
        ),
      ),
    );
  }

  _dataItem(String title, String data, {double? topPadding, int? flex}) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding ?? 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: flex ?? 1,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            " : ",
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF5DB075),
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            flex: flex ?? 3,
            child: Text(
              data,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
