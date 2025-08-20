import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nnf/dashboard.dart';
import 'package:nnf/provider/habit_provider.dart';
import 'package:nnf/register.dart';
import 'package:nnf/rewards.dart';
import 'package:nnf/routes/route_names.dart';
import 'package:nnf/welcome.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  ref.watch(habitProvider.notifier);
  
  return GoRouter(
    // Set initial location based on registration status
    initialLocation: '/initial',
    routes: [
      // Initial route that redirects based on registration status
      GoRoute(
        path: '/initial',
        name: 'initial',
        redirect: (context, state) {
          final habitData = ref.read(habitProvider);
          // Check if user is registered (has username and required data)
          if (habitData.isRegistered && 
              habitData.username != null && 
              habitData.username!.isNotEmpty) {
            return '/welcome';
          } else {
            return '/register';
          }
        },
        builder: (context, state) => const Register(), // Fallback (shouldn't be reached)
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