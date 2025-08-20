import 'package:go_router/go_router.dart';
import 'package:nnf/dashboard.dart';
import 'package:nnf/provider/habit_provider.dart';
import 'package:nnf/register.dart';
import 'package:nnf/rewards.dart';
import 'package:nnf/routes/route_names.dart';
import 'package:nnf/welcome.dart';
import 'package:riverpod/riverpod.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: ref.watch(habitProvider).username == null? '/register' : '/welcome',
    routes: [
      GoRoute(
        path: '/welcome',
        name: AppRouteNames.welcome,
        builder: (context, state) => const Welcome(),
      ),
      GoRoute(
        path: '/dashboard',
        name: AppRouteNames.dashboard,
        builder: (context, state) => const Dashboard(),
      ),
      GoRoute(
        path: '/rewards',
        name: AppRouteNames.rewards,
        builder: (context, state) => const Rewards(),
      ),
      GoRoute(
        path: '/register',
        name: AppRouteNames.register,
        builder: (context, state) => const Register(),
      ),
    ],
  );
});