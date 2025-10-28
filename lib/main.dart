import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/provider/auth/auth_provider.dart';
import 'package:geumpumta/screens/login/login.dart';
import 'package:geumpumta/screens/main/main.dart';
import 'package:geumpumta/routes/app_routes.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    final isLoggedIn = ref.watch(authProvider);

    return isLoggedIn ? const MainScreen() : const LoginScreen();
    // return const MainScreen(); // 이거 주석 해제하시면 메인 페이지로 바로 이동합니당
    // return const 페이지(); // 이렇게 생성해서 바로 연결되도록 하세요!
  }
}
