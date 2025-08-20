import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nnf/popups/genereic_popup.dart';
import 'package:nnf/provider/habit_provider.dart';
import 'package:nnf/routes/route_names.dart';

Future showFailPopup({
  required BuildContext context,
  required WidgetRef ref,
}) {
  final habitData = ref.read(habitProvider); 
  return showGenericPopup(
    context: context,
    title: 'You Failed Today',
    content: 'You failed today, but tomorrow is a new opportunity. Don\'t give up on your journey!',
    imagePath: habitData.failureImagePath,
    optionsBuilder: () => {
      'Try Again Tomorrow': () {
         ref.read(habitProvider.notifier).recordFailure();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            context.goNamed(AppRouteNames.dashboard);
          }
        });
      },
    },
  );
}