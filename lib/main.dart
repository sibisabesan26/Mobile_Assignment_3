import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/order_plan_screen.dart';
import 'screens/query_screen.dart';
import 'screens/manage_food_screen.dart';
import 'screens/food_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Ordering App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Start at splash
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/plan': (_) => const OrderPlanScreen(),
        '/query': (_) => const QueryScreen(),
        '/manage': (_) => const ManageFoodScreen(),
        '/foods': (_) => const FoodListScreen(),
      },
    );
  }
}
