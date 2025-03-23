import 'package:cristatepro/util/onboarding.dart';
import 'package:get/get.dart';
import 'package:cristatepro/util/splash_screen.dart';
import 'package:cristatepro/user/authentication/sign_in.dart';
import 'package:cristatepro/user/fragments/home/home_fragment_screen.dart';
import 'package:cristatepro/admin/model/dashboard.dart';

class Routes {
  static var routes = [
    GetPage(name: "/", page: () => SplashScreen()),
    GetPage(name: "/onboarding", page: () => OnboardingScreen()),
    GetPage(name: "/home", page: () => HomeFragmentScreen()),
    GetPage(name: "/signin", page: () => SignInScreen()),
    GetPage(name: "/dashboard", page: () => const Dashboard()),
  ];
}
