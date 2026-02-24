import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'config/app_theme.dart';
import 'config/app_strings.dart';

// === شاشات مؤقتة للتجربة ===
class TempScreen extends StatelessWidget {
  final String title;
  const TempScreen({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: Text('هذه شاشة $title', style: const TextStyle(fontSize: 24))),
  );
}

// === الهيكل الرئيسي (الشريط السفلي) ===
class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // تحديد مسار التوجيه الحالي لمعرفة أي أيقونة نفعلها
    final String location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    if (location.startsWith('/invoices')) currentIndex = 1;
    if (location.startsWith('/transfers')) currentIndex = 2; // المناقلات
    if (location.startsWith('/customers')) currentIndex = 3;
    if (location.startsWith('/settings')) currentIndex = 4;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (int index) {
          switch (index) {
            case 0: context.go('/'); break;
            case 1: context.go('/invoices'); break;
            case 2: context.go('/transfers'); break;
            case 3: context.go('/customers'); break;
            case 4: context.go('/settings'); break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'الفواتير'),
          NavigationDestination(icon: Icon(Icons.swap_horiz_outlined), selectedIcon: Icon(Icons.swap_horiz), label: 'المناقلات'),
          NavigationDestination(icon: Icon(Icons.people_outlined), selectedIcon: Icon(Icons.people), label: 'الزبائن'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'الإعدادات'),
        ],
      ),
    );
  }
}

// === إعداد الموجه (Go Router) ===
final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/', builder: (context, state) => const TempScreen(title: AppStrings.homeTitle)),
        GoRoute(path: '/invoices', builder: (context, state) => const TempScreen(title: AppStrings.invoices)),
        GoRoute(path: '/transfers', builder: (context, state) => const TempScreen(title: AppStrings.transfers)),
        GoRoute(path: '/customers', builder: (context, state) => const TempScreen(title: AppStrings.customers)),
        GoRoute(path: '/settings', builder: (context, state) => const TempScreen(title: AppStrings.settings)),
      ],
    ),
  ],
);

// === الكلاس الرئيسي للتطبيق ===
class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // إعدادات اللغة العربية (RTL)
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'AE'), // تحديد اللغة العربية
      ],
      locale: const Locale('ar', 'AE'),

      routerConfig: goRouter,
    );
  }
}