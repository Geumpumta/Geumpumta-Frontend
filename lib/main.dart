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
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: 'SCDream',
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
      routes: AppRoutes.routes,
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  bool _isChecking = true;
  bool _hasToken = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final userString = prefs.getString('userInfo');

    // 토큰과 사용자 정보가 모두 있어야 메인 화면으로
    final hasValidAuth = accessToken != null && 
                        accessToken.isNotEmpty && 
                        userString != null;

    if (mounted) {
      setState(() {
        _hasToken = hasValidAuth;
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final user = ref.watch(userInfoStateProvider);

    // 토큰이 없거나 사용자 정보가 없으면 로그인 화면
    if (!_hasToken || user == null || user.userRole != 'USER') {
      return const LoginScreen();
    }

    return const MainScreen();
  }
}
