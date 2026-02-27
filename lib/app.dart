import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'config/app_theme.dart';
import 'config/app_strings.dart';
import 'screens/settings/warehouses_screen.dart';
import 'screens/settings/categories_screen.dart';
import 'screens/settings/products_screen.dart';
import 'screens/settings/product_form_screen.dart';
import 'screens/settings/accounts_screen.dart';
import 'screens/customers/customers_list_screen.dart';
import 'screens/customers/customer_form_screen.dart';
import 'screens/invoices/invoices_list_screen.dart';
import 'screens/invoices/invoice_form_screen.dart';

// استيراد الشاشات الحقيقية
import 'screens/settings/settings_screen.dart';
import 'screens/settings/protected_settings_screen.dart';

// === الشاشات المؤقتة لباقي التبويبات ===
class TempScreen extends StatelessWidget {
  final String title;
  const TempScreen({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: Text('هذه شاشة $title', style: const TextStyle(fontSize: 24))),
  );
}

// === الهيكل الرئيسي (MainShell) كما هو بدون تغيير ===
class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    if (location.startsWith('/invoices')) currentIndex = 1;
    if (location.startsWith('/transfers')) currentIndex = 2;
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

// === تحديث الـ Router ===
final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/', builder: (context, state) => const TempScreen(title: AppStrings.homeTitle)),
        GoRoute(path: '/invoices', builder: (context, state) => const InvoicesListScreen()),
        GoRoute(path: '/transfers', builder: (context, state) => const TempScreen(title: AppStrings.transfers)),
        GoRoute(path: '/customers', builder: (context, state) => const CustomersListScreen()),
        // ربط شاشة الإعدادات الحقيقية
        GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
      ],
    ),
    // شاشة الإعدادات المحمية تكون خارج الـ Shell (تأخذ الشاشة كاملة بدون الشريط السفلي)
    GoRoute(
        path: '/protected_settings',
        builder: (context, state) => const ProtectedSettingsScreen()
    ),
    // [جديد] مسار شاشة إدارة المستودعات
    GoRoute(
        path: '/manage_warehouses',
        builder: (context, state) => const WarehousesScreen()
    ),
    GoRoute(
        path: '/manage_categories',
        builder: (context, state) => const CategoriesScreen()
    ),
    // [جديد] مسار شاشة إضافة/تعديل المادة
    GoRoute(
      path: '/product_form/:categoryId/:productId',
      builder: (context, state) {
        final categoryId = int.parse(state.pathParameters['categoryId']!);
        final productId = int.parse(state.pathParameters['productId']!);
        return ProductFormScreen(categoryId: categoryId, productId: productId);
      },
    ),
    // [جديد] مسار إدارة الحسابات
    GoRoute(
      path: '/manage_accounts',
      builder: (context, state) => const AccountsScreen(),
    ),
    // مسار إضافة وتعديل الزبون
    GoRoute(
      path: '/customer_form/:customerId',
      builder: (context, state) {
        final customerId = int.parse(state.pathParameters['customerId']!);
        return CustomerFormScreen(customerId: customerId);
      },
    ),
    // مسار الفاتورة (مبيعات أو مرتجعات)
    GoRoute(
      path: '/invoice_form/:type/:invoiceId',
      builder: (context, state) {
        final type = state.pathParameters['type']!;
        final invoiceId = int.parse(state.pathParameters['invoiceId']!);
        return InvoiceFormScreen(type: type, invoiceId: invoiceId);
      },
    ),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar', 'AE')],
      locale: const Locale('ar', 'AE'),
      routerConfig: goRouter,
    );
  }
}