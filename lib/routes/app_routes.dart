import 'package:flutter/cupertino.dart';
import 'package:geumpumta/screens/login/login.dart';
import 'package:geumpumta/screens/main/main.dart';
import 'package:geumpumta/screens/signin/sign_in_1.dart';
import 'package:geumpumta/screens/signin/sign_in_2.dart';
import 'package:geumpumta/screens/signin/sign_in_3.dart';

class AppRoutes{
  static const String login = '/login';
  static const String signin1 = '/signin1';
  static const String signin2 = '/signin2';
  static const String signin3 = '/signin3';
  static const String main = '/main';

  static Map<String, WidgetBuilder> routes = {
    login:(context) => const LoginScreen(),
    signin1:(context)=>const SignIn1Screen(),
    signin2:(context)=>const SignIn2Screen(),
    signin3:(context)=>const SignIn3Screen(),
    main : (context)=> const MainScreen(),
  };
}