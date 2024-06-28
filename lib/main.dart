import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:truck_moves/config.dart';
import 'package:truck_moves/models/driver.dart';
import 'package:truck_moves/providers/auth_provider.dart';
import 'package:truck_moves/providers/job_provider.dart';
import 'package:truck_moves/ui/landing/login_page/login_page.dart';
import 'package:truck_moves/ui/mp/home/home_page.dart';
import 'package:truck_moves/utils/cache_manager.dart';
import 'package:truck_moves/utils/custom_http.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Driver? driver = await CacheManger.getDriver();
  CustomHttp.setInterceptor(token: driver?.jwtToken);
  runApp(MyApp(driver: driver));
}

class MyApp extends StatelessWidget {
  final Driver? driver;
  const MyApp({super.key, this.driver});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(driver)),
        ChangeNotifierProvider(create: (_) => JobProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(428, 926),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Truck Moves',
            navigatorKey: navigatorKey,
            // scaffoldMessengerKey: rootScaffoldMessengerKey,
            theme: ThemeData(
              primaryColor: AppColors.bgColor,
              scaffoldBackgroundColor: AppColors.bgColor,
              // brightness: Brightness.dark,
              primarySwatch: const MaterialColor(0xFFFFD000, <int, Color>{
                50: Color(0x0DFFD000),
                100: Color(0x1AFFD000),
                200: Color(0x33FFD000),
                300: Color(0x4DFFD000),
                400: Color(0x66FFD000),
                500: Color(0x80FFD000),
                600: Color(0x99FFD000),
                700: Color(0xB3FFD000),
                800: Color(0xCCFFD000),
                900: Color(0xE6FFD000),
              }),
              textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            ),
            home: child,
          );
        },
        child: driver != null ? const HomePage() : const LoginPage(),
      ),
    );
  }
}
