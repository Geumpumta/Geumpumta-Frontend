import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:geumpumta/provider/userState/user_info_state.dart';
import 'package:geumpumta/provider/notification/fcm_provider.dart';
import 'package:geumpumta/provider/repository_provider.dart';
import 'package:geumpumta/core/navigation/app_navigator.dart';
import 'package:geumpumta/screens/login/login.dart';
import 'package:geumpumta/screens/main/main.dart';
import 'package:geumpumta/screens/signin/sign_in_1.dart';
import 'package:geumpumta/viewmodel/user/user_viewmodel.dart';
import 'package:geumpumta/routes/app_routes.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geumpumta/models/entity/user/user.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
final FirebaseAnalyticsObserver firebaseAnalyticsObserver =
    FirebaseAnalyticsObserver(analytics: firebaseAnalytics);

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
      navigatorObservers: [routeObserver, firebaseAnalyticsObserver],
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
  bool _shouldShowUpdateDialog = false;
  bool _didShowUpdateDialog = false;
  String? _updateStoreUrl;
  String? _latestStoreVersion;

  @override
  void initState() {
    super.initState();
    _checkInitialState();
  }

  Future<void> _checkInitialState() async {
    try {
      final maintenanceRepo = ref.read(maintenanceRepositoryProvider);
      final maintenanceStatus = await maintenanceRepo
          .getMaintenanceStatus()
          .timeout(const Duration(seconds: 5));

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
      final hasAccessToken = accessToken != null && accessToken.isNotEmpty;

      var hasValidAuth = hasAccessToken && userString != null;

      if (hasAccessToken && userString == null) {
        hasValidAuth = await _restoreSessionFromStoredToken();
      }

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

      unawaited(
        _checkForAppUpdate().catchError((Object error, StackTrace stackTrace) {
          debugPrint('Deferred app update check failed: $error');
          debugPrintStack(stackTrace: stackTrace);
        }),
      );
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

  Future<bool> _restoreSessionFromStoredToken() async {
    try {
      final user = await ref.read(userViewModelProvider.notifier).loadUserProfile();
      if (user == null) {
        await _clearStoredAuth();
        return false;
      }

      await ref.read(userInfoStateProvider.notifier).setUser(user);
      return true;
    } catch (error, stackTrace) {
      debugPrint('Stored session restore failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      await _clearStoredAuth();
      return false;
    }
  }

  Future<void> _clearStoredAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('userInfo');
    await ref.read(userInfoStateProvider.notifier).clear();
  }

  Future<void> _checkForAppUpdate() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }

    try {
      final newVersion = NewVersionPlus(
        androidId: 'com.geumpumgalchwi.geumpumta',
        iOSAppStoreCountry: 'kr',
      );

      final status = await newVersion
          .getVersionStatus()
          .timeout(const Duration(seconds: 5));
      if (!mounted || status == null || !status.canUpdate) {
        return;
      }

      final appStoreLink = status.appStoreLink;
      if (appStoreLink.isEmpty) {
        return;
      }

      setState(() {
        _shouldShowUpdateDialog = true;
        _updateStoreUrl = appStoreLink;
        _latestStoreVersion = status.storeVersion;
      });
    } catch (error, stackTrace) {
      debugPrint('App update check failed: $error');
      debugPrintStack(stackTrace: stackTrace);
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

    _showUpdateDialogIfNeeded(context);

    final user = ref.watch(userInfoStateProvider);

    if (!_hasToken || user == null) {
      return const LoginScreen();
    }

    final normalizedRole = (user.userRole ?? '').trim().toUpperCase();
    if (normalizedRole == 'GUEST') {
      return const SignIn1Screen();
    }
    if (normalizedRole != 'USER' && normalizedRole != 'ADMIN') {
      return const LoginScreen();
    }

    return const MainScreen();
  }

  void _showUpdateDialogIfNeeded(BuildContext context) {
    if (!_shouldShowUpdateDialog || _didShowUpdateDialog) {
      return;
    }
    _didShowUpdateDialog = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text(
              '새 업데이트가 있어요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            content: Text(
              _latestStoreVersion == null
                  ? '더 좋은 사용성을 위해 최신 버전으로 업데이트해 주세요.'
                  : '최신 버전(v$_latestStoreVersion)이 출시되었습니다.\n업데이트 후 더 안정적으로 이용할 수 있어요.',
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text(
                  '나중에 하기',
                  style: TextStyle(
                    color: Color(0xFF888888),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  await _openStoreForUpdate();
                },
                child: const Text(
                  '업데이트 하러가기',
                  style: TextStyle(
                    color: Color(0xFF0BAEFF),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  Future<void> _openStoreForUpdate() async {
    final storeUrl = _updateStoreUrl;
    if (storeUrl == null || storeUrl.isEmpty) {
      return;
    }

    final uri = Uri.tryParse(storeUrl);
    if (uri == null) {
      return;
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('스토어를 열 수 없습니다.')));
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('스토어 이동에 실패했습니다: $error')));
    }
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '서비스 점검 중입니다',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _maintenanceMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.55,
                      color: Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(height: 12),
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
      backgroundColor: Color(0xFFC7E5FA),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/splash/splash_logo.png',
            fit: BoxFit.contain,
            alignment: Alignment.topCenter,
          ),
          if (_isChecking) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
