import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:geumpumta/provider/userState/user_info_state.dart';
import 'package:geumpumta/provider/notification/fcm_provider.dart';
import 'package:geumpumta/core/navigation/app_navigator.dart';
import 'package:geumpumta/screens/login/login.dart';
import 'package:geumpumta/screens/main/main.dart';
import 'package:geumpumta/routes/app_routes.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geumpumta/models/entity/user/user.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  final userString = prefs.getString('userInfo');

  User? initialUser;
  if (userString != null) {
    initialUser = User.fromJson(jsonDecode(userString));
  }

  await dotenv.load(fileName: ".env");
  kakao.KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']!);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ProviderScope(
      overrides: [
        userInfoStateProvider.overrideWith((ref) {
          final notifier = UserInfoNotifier();
          if (initialUser != null) notifier.setUser(initialUser);
          return notifier;
        }),
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
      navigatorKey: rootNavigatorKey,
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        useMaterial3: false,
        textTheme: GoogleFonts.ibmPlexSansKrTextTheme(
          Theme.of(context).textTheme,
        ),
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
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final userString = prefs.getString('userInfo');

      final hasValidAuth =
          accessToken != null && accessToken.isNotEmpty && userString != null;

      if (mounted) {
        setState(() {
          _hasToken = hasValidAuth;
        });
      }

      if (hasValidAuth) {
        unawaited(
          ref.read(fcmServiceProvider).initAndRegisterToken().catchError((
            Object error,
            StackTrace stackTrace,
          ) {
            debugPrint('FCM init failed: $error');
          }),
        );
      }
    } catch (error, stackTrace) {
      debugPrint('Auth check failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (mounted) {
        setState(() {
          _hasToken = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = ref.watch(userInfoStateProvider);

    if (!_hasToken || user == null || user.userRole != 'USER') {
      return const LoginScreen();
    }

    return const MainScreen();
  }
}
