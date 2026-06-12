import 'package:flutter/material.dart';
import 'package:secure_admin/core/utils/service_locator.dart';
import 'core/routing/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(const SecureAdminApp());
}

class SecureAdminApp extends StatelessWidget {
  const SecureAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Secure Admin Panel',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        primaryColor: const Color(0xFF00E676),
        fontFamily: 'monospace',
      ),
      routerConfig: appRouter,
    );
  }
}


// test