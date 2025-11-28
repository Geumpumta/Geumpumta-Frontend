import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/provider/userState/user_info_state.dart';
import 'package:geumpumta/screens/login/login.dart';
import 'package:geumpumta/screens/main/main.dart';
import 'package:geumpumta/routes/app_routes.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geumpumta/models/entity/user/user.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final userString = prefs.getString('userInfo');

  User? initialUser;
  if (userString != null) {
    initialUser = User.fromJson(jsonDecode(userString));
  }

  await dotenv.load(fileName: ".env");
  kakao.KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']!);

  runApp(
    ProviderScope(
      overrides: [
        userInfoStateProvider.overrideWith(
              (ref) {
            final notifier = UserInfoNotifier();
            if (initialUser != null) notifier.setUser(initialUser);
            return notifier;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      theme: ThemeData(useMaterial3: false),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
      routes: AppRoutes.routes,
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userInfoStateProvider);

    if (user?.userRole == 'USER') {
      return const MainScreen();
    } else {
      return const LoginScreen();
    }
  }
}
