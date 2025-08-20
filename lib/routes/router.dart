import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nnf/dashboard.dart';
import 'package:nnf/provider/habit_provider.dart';
import 'package:nnf/register.dart';
import 'package:nnf/rewards.dart';
import 'package:nnf/routes/route_names.dart';
import 'package:nnf/welcome.dart';

// Loading screen widget
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              'Loading your data...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    // Set initial location
    initialLocation: '/loading',
    routes: [
      // Loading route that waits for data to load
      GoRoute(
        path: '/loading',
        name: 'loading',
        builder: (context, state) {
          return Consumer(
            builder: (context, ref, child) {
              final habitData = ref.watch(habitProvider);
              
              // Use a post frame callback to navigate after build completes
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  if (habitData.isRegistered && 
                      habitData.username != null && 
                      habitData.username!.isNotEmpty) {
                    context.go('/welcome');
                  } else {
                    context.go('/register');
                  }
                }
              });
              
              return const LoadingScreen();
            },
          );
        },
      ),
      
      GoRoute(
        path: '/register',
        name: AppRouteNames.register,
        builder: (context, state) => const Register(),
      ),
      
      GoRoute(
        path: '/welcome',
        name: AppRouteNames.welcome,
        builder: (context, state) => const Welcome(),
        // Redirect to register if not registered
        redirect: (context, state) {
          final habitData = ref.read(habitProvider);
          if (!habitData.isRegistered || 
              habitData.username == null || 
              habitData.username!.isEmpty) {
            return '/register';
          }
          return null; // Allow access to welcome
        },
      ),
      
      GoRoute(
        path: '/dashboard',
        name: AppRouteNames.dashboard,
        builder: (context, state) => const Dashboard(),
        // Redirect to register if not registered
        redirect: (context, state) {
          final habitData = ref.read(habitProvider);
          if (!habitData.isRegistered || 
              habitData.username == null || 
              habitData.username!.isEmpty) {
            return '/register';
          }
          return null; // Allow access to dashboard
        },
      ),
      
      GoRoute(
        path: '/rewards',
        name: AppRouteNames.rewards,
        builder: (context, state) => const Rewards(),
        // Redirect to register if not registered
        redirect: (context, state) {
          final habitData = ref.read(habitProvider);
          if (!habitData.isRegistered || 
              habitData.username == null || 
              habitData.username!.isEmpty) {
            return '/register';
          }
          return null; // Allow access to rewards
        },
      ),
    ],
  );
});