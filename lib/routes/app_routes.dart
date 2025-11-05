import 'package:flutter/cupertino.dart';
import 'package:geumpumta/screens/login/login.dart';
import 'package:geumpumta/screens/main/main.dart';
import 'package:geumpumta/screens/signin/sign_in_1.dart';
import 'package:geumpumta/screens/signin/sign_in_2.dart';
import 'package:geumpumta/screens/signin/sign_in_3.dart';
import 'package:geumpumta/screens/more/more.dart';
import 'package:geumpumta/screens/more/widgets/placeholder_screen.dart';
import 'package:geumpumta/screens/more/widgets/profile_edit_screen.dart';

class AppRoutes{
  static const String login = '/login';
  static const String signin1 = '/signin1';
  static const String signin2 = '/signin2';
  static const String signin3 = '/signin3';
  static const String main = '/main';
  static const String more = '/more';
  static const String placeholder = '/placeholder';
  static const String profileEdit = '/profile_edit';

  static Map<String, WidgetBuilder> routes = {
    login:(context) => const LoginScreen(),
    signin1:(context)=>const SignIn1Screen(),
    signin2:(context)=>const SignIn2Screen(),
    signin3:(context)=>const SignIn3Screen(),
    main : (context)=> const MainScreen(),
    more : (context)=> const MoreScreen(),
    placeholder : (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?; // 타입검증 해야함
      final title = args?['title'] as String? ?? ''; // 전달받은 인자가 없더라도 안전하게 처리
      return PlaceholderScreen(title: title);
    },
    profileEdit : (context)=> const ProfileEditScreen(),
  };
}