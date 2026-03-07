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
import 'screens/transfers/transfers_list_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/vouchers/voucher_form_screen.dart';
import 'screens/transfers/transfer_form_screen.dart';

// 🔴 1. استيراد شاشة السندات الجديدة
import 'screens/vouchers/vouchers_list_screen.dart';

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

// === الهيكل الرئيسي (MainShell) وتحديث شريط التنقل ===
class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;

    // 🔴 2. تحديث ترتيب التبويبات (أضفنا السندات في المنتصف)
    if (location.startsWith('/invoices')) currentIndex = 1;
    if (location.startsWith('/vouchers')) currentIndex = 2; // مسار السندات
    if (location.startsWith('/transfers')) currentIndex = 3;
    if (location.startsWith('/customers')) currentIndex = 4;
    if (location.startsWith('/settings')) currentIndex = 5;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (int index) {
          switch (index) {
            case 0: context.go('/'); break;
            case 1: context.go('/invoices'); break;
            case 2: context.go('/vouchers'); break; // الانتقال للسندات
            case 3: context.go('/transfers'); break;
            case 4: context.go('/customers'); break;
            case 5: context.go('/settings'); break;
          }
        },
        destinations: const[
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'الفواتير'),
          NavigationDestination(icon: Icon(Icons.monetization_on_outlined), selectedIcon: Icon(Icons.monetization_on), label: 'السندات'),
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
  routes:[
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes:[
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(path: '/invoices', builder: (context, state) => const InvoicesListScreen()),
        GoRoute(path: '/vouchers', builder: (context, state) => const VouchersListScreen()),
        GoRoute(path: '/transfers', builder: (context, state) => const TransfersListScreen()),
        GoRoute(path: '/customers', builder: (context, state) => const CustomersListScreen()),
        GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
      ],
    ),
    GoRoute(
        path: '/protected_settings',
        builder: (context, state) => const ProtectedSettingsScreen()
    ),
    GoRoute(
        path: '/manage_warehouses',
        builder: (context, state) => const WarehousesScreen()
    ),
    GoRoute(
        path: '/manage_categories',
        builder: (context, state) => const CategoriesScreen()
    ),
    GoRoute(
      path: '/product_form/:categoryId/:productId',
      builder: (context, state) {
        final categoryId = int.parse(state.pathParameters['categoryId']!);
        final productId = int.parse(state.pathParameters['productId']!);
        return ProductFormScreen(categoryId: categoryId, productId: productId);
      },
    ),
    GoRoute(
      path: '/manage_accounts',
      builder: (context, state) => const AccountsScreen(),
    ),
    GoRoute(
      path: '/customer_form/:customerId',
      builder: (context, state) {
        final customerId = int.parse(state.pathParameters['customerId']!);
        return CustomerFormScreen(customerId: customerId);
      },
    ),
    GoRoute(
      path: '/invoice_form/:type/:invoiceId',
      builder: (context, state) {
        final type = state.pathParameters['type']!;
        final invoiceId = int.parse(state.pathParameters['invoiceId']!);
        return InvoiceFormScreen(type: type, invoiceId: invoiceId);
      },
    ),
    // الإضافة الجديدة: مسار نموذج السندات
    GoRoute(
      path: '/voucher_form/:type/:voucherId',
      builder: (context, state) {
        final type = state.pathParameters['type']!;
        final voucherId = int.parse(state.pathParameters['voucherId']!);
        return VoucherFormScreen(type: type, voucherId: voucherId);
      },
    ),

    // الإضافة الجديدة: مسار نموذج المناقلات
    GoRoute(
      path: '/transfer_form/:transferId',
      builder: (context, state) {
        final transferId = int.parse(state.pathParameters['transferId']!);
        return TransferFormScreen(transferId: transferId);
      },
    ),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName ?? 'التطبيق',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      localizationsDelegates: const[
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