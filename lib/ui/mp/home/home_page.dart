import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:truck_moves/constant.dart';
import 'package:truck_moves/providers/auth_provider.dart';
import 'package:truck_moves/services/auth_service.dart';
import 'package:truck_moves/shared_widgets/confirmation_popup.dart';
import 'package:truck_moves/shared_widgets/page_loaders.dart';
import 'package:truck_moves/ui/landing/login_page/login_page.dart';
import 'package:truck_moves/ui/mp/home/current_jobs.dart';
import 'package:truck_moves/ui/mp/home/future_jobs.dart';
import 'package:truck_moves/utils/cache_manager.dart';
import 'package:truck_moves/utils/custom_http.dart';
import 'package:truck_moves/utils/hero_dialog_route.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageNo = 0;
  late PageController _pageController;
  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _logout() async {
    PageLoader.showLoader(context);
    await AuthService.logout();
    if (mounted) Navigator.pop(context);
    await CacheManger.removeDriver();
    if (mounted) {
      CustomHttp.setInterceptor(token: null);
      context.read<AuthProvider>().removeDriver();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        centerTitle: false,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        elevation: 0,
        title: FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Text(
            "Hi ${context.watch<AuthProvider>().driver.firstName} ${context.watch<AuthProvider>().driver.lastName}",
            style: TextStyle(
                fontSize: 22.sp,
                color: Colors.white,
                fontWeight: FontWeight.w800),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                HeroDialogRoute(
                  builder: (BuildContext context) => ConfirmationPopup(
                    title: "Logout",
                    message:
                        "Are you sure you want to logout from your account?",
                    leftBtnText: "NO",
                    rightBtnText: "YES",
                    onRightTap: () {
                      _logout();
                    },
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.power_settings_new_rounded,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.h),
              child: Row(
                children: [
                  _tabButton(label: "Current Jobs", index: 0),
                  _tabButton(label: "Future Jobs", index: 1),
                ],
              ),
            ),
          ),
          Expanded(
              child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: const [
              CurrentJobs(),
              FutureJobs(),
            ],
          ))
        ],
      )),
    );
  }

  _tabButton({required String label, required int index}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _pageController.jumpToPage(index);
          setState(() {
            _pageNo = index;
          });
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          height: 50.h,
          decoration: BoxDecoration(
              border: Border.all(
                  color: _pageNo == index ? primaryColor : Colors.transparent),
              color: _pageNo == index ? primaryColor : const Color(0xFF2E4867)),
          child: FittedBox(
            alignment: Alignment.center,
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 18.sp,
                  color: _pageNo == index ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
