import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:truck_moves/constant.dart';
// import 'package:truck_moves/constant.dart';
import 'package:truck_moves/providers/auth_provider.dart';
import 'package:truck_moves/services/auth_service.dart';
import 'package:truck_moves/shared_widgets/input_field.dart';
import 'package:truck_moves/shared_widgets/network_error_bottom_sheet.dart';
import 'package:truck_moves/shared_widgets/page_loaders.dart';
import 'package:truck_moves/shared_widgets/submit_button.dart';
import 'package:truck_moves/ui/mp/home/home_page.dart';
import 'package:truck_moves/utils/cache_manager.dart';
import 'package:truck_moves/utils/custom_http.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  // bool rememberMe = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _attemptLogin() async {
    PageLoader.showLoader(context);
    final res = await AuthService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());
    if (mounted) Navigator.pop(context);
    res.when(success: (data) async {
      await CacheManger.saveDriver(driver: data);
      if (mounted) {
        CustomHttp.setInterceptor(token: data.jwtToken);
        context.read<AuthProvider>().setDriver(data);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
      }
    }, failure: (error) {
      showErrorSheet(context: context, exception: error, login: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidateMode,
              child: Column(
                children: [
                  const Spacer(),
                  SvgPicture.asset(
                    "assets/icons/logo.svg",
                    height: 120.h,
                    width: 180.w,
                    // fit: BoxFit.fill,
                    colorFilter:
                        ColorFilter.mode(primaryColor, BlendMode.srcIn),
                  ),
                  const Spacer(),
                  Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  InputField(
                    width: 380.w,
                    hintText: "Email",
                    labelText: "Email",
                    prefixIcon: Icons.email_outlined,
                    controller: _emailController,
                    textInputType: TextInputType.emailAddress,
                    validator: (v) {
                      if ((v ?? "").isEmpty) {
                        return "Provide an email";
                      }
                      if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(v ?? "")) {
                        return "Email address is invalid";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  InputField(
                    width: 380.w,
                    hintText: "Password",
                    labelText: "Password",
                    prefixIcon: Icons.key,
                    controller: _passwordController,
                    textInputType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: (v) {
                      if ((v ?? "").isEmpty) {
                        return "Provide a password";
                      }
                      return null;
                    },
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 10.w),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Row(
                  //         children: [
                  //           Theme(
                  //             data: ThemeData(
                  //               unselectedWidgetColor: Colors.white,
                  //             ),
                  //             child: Checkbox(
                  //               value: rememberMe,
                  //               onChanged: (bool? value) {
                  //                 setState(() {
                  //                   rememberMe = value!;
                  //                 });
                  //               },
                  //               activeColor: primaryColor,
                  //             ),
                  //           ),
                  //           const Text(
                  //             'Remember me',
                  //             style: TextStyle(
                  //               fontWeight: FontWeight.w400,
                  //               color: Colors.white,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       GestureDetector(
                  //         child: Text(
                  //           'Forgot password?',
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             color: primaryColor,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 30.h,
                  ),
                  SubmitButton(
                    label: "Login",
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState?.validate() ?? false) {
                        _attemptLogin();
                      }
                      setState(() {
                        _autoValidateMode = AutovalidateMode.onUserInteraction;
                      });
                    },
                    width: 275.w,
                  ),
                  const Spacer(),
                  const Spacer(),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
