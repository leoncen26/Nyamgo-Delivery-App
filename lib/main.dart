import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nyamgo/pages/order_status_page.dart';
import 'package:nyamgo/provider/auth_provider.dart';
import 'package:nyamgo/admin/admin_page.dart';
import 'package:nyamgo/auth/login_page.dart';
import 'package:nyamgo/auth/register_page.dart';
import 'package:nyamgo/firebase_options.dart';
import 'package:nyamgo/pages/home_page.dart';
import 'package:nyamgo/pages/main_page.dart';
import 'package:nyamgo/pages/welcome_page.dart';
import 'package:nyamgo/provider/cart_provider.dart';
import 'package:nyamgo/provider/option_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider(create: (_) => OptionProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: 'welcome',
      routes: {
        'welcome': (context) => const WelcomePage(),
        'login': (context) => const LoginPage(),
        'register': (context) => const RegisterPage(),
        'home': (context) => const HomePage(),
        'main': (context) => const MainPage(),
        'admin': (context) => const AdminPage(),
        'orderStatus': (context) => const OrderStatusPage(),
      },
    );
  }
}
