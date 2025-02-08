import 'package:flutter_test_app/pages/auth_wraper.dart';
import 'package:flutter_test_app/pages/famous_home.dart';
import 'package:flutter_test_app/pages/fan_home.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test_app/pages/login_page.dart';
import 'package:flutter_test_app/pages/register_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final isLoggingIn = state.matchedLocation == '/login' || 
                         state.matchedLocation == '/register';
      
      if (user == null && !isLoggingIn) {
        return '/login';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>  AuthWrapper(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) =>  LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
          GoRoute(
      path: '/fanHome',
      builder: (context, state) => const FanHome(),
    ),
    GoRoute(
      path: '/famosoHome',
      builder: (context, state) => const FamousHome(),
    ),
    ],
  );
}