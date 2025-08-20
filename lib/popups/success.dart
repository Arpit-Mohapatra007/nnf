import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nnf/popups/genereic_popup.dart';
import 'package:nnf/provider/habit_provider.dart';
import 'package:nnf/routes/route_names.dart';

Future showSuccessPopup({
  required BuildContext context,
  required WidgetRef ref,
}) {
  final habitData = ref.read(habitProvider); 
  return showGenericPopup(
    context: context,
    title: 'Great Job!',
    content: 'Proud of your commitment today! Keep the momentum going and stay strong!',
    imagePath: habitData.successImagePath,
    optionsBuilder: () => {
      'Continue Journey': () {
        ref.read(habitProvider.notifier).recordSuccess();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            context.goNamed(AppRouteNames.dashboard);
          }
        });
      },
    },
  );
}