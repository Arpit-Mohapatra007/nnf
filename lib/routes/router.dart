import 'package:go_router/go_router.dart';
import 'package:nnf/dashboard.dart';
import 'package:nnf/rewards.dart';
import 'package:nnf/routes/route_names.dart';
import 'package:nnf/welcome.dart';
import 'package:riverpod/riverpod.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRouteNames.welcome,
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
    ],
  );
});