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
import 'package:geumpumta/provider/repository_provider.dart';
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
  bool _isMaintenance = false;
  String _maintenanceMessage = '서버 점검 중입니다.';
  bool _didShowMaintenanceDialog = false;

  @override
  void initState() {
    super.initState();
    _checkInitialState();
  }

  Future<void> _checkInitialState() async {
    try {
      final maintenanceRepo = ref.read(maintenanceRepositoryProvider);
      final maintenanceStatus = await maintenanceRepo.getMaintenanceStatus();

      if (maintenanceStatus.isMaintenance) {
        if (mounted) {
          final serverMessage = maintenanceStatus.message?.trim();
          setState(() {
            _isMaintenance = true;
            _maintenanceMessage =
                (serverMessage == null || serverMessage.isEmpty)
                ? '서버 점검 중입니다.'
                : serverMessage;
          });
        }
        return;
      }

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
          _isMaintenance = false;
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
      return _buildSplashScaffold();
    }

    if (_isMaintenance) {
      _showMaintenanceDialogIfNeeded(context);
      return _buildSplashScaffold();
    }

    final user = ref.watch(userInfoStateProvider);

    if (!_hasToken || user == null || user.userRole != 'USER') {
      return const LoginScreen();
    }

    return const MainScreen();
  }

  void _showMaintenanceDialogIfNeeded(BuildContext context) {
    if (_didShowMaintenanceDialog) {
      return;
    }
    _didShowMaintenanceDialog = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/image/maintenance/maintenance_icon.png',
                      width: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '서비스 점검 중입니다',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _maintenanceMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.55,
                      color: Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '앱을 종료한 뒤 잠시 후 다시 실행해 주세요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7A7A7A),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildSplashScaffold() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/splash/splash_logo.png', fit: BoxFit.cover),
          if (_isChecking)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
