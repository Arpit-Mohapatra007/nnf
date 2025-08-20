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
  return showGenericPopup(
    context: context,
    title: 'Great Job!',
    content: 'Proud of your commitment today! Keep the momentum going!',
    optionsBuilder: () => {
      'OK': () {
        ref.read(habitProvider.notifier).recordSuccess(); 
        context.goNamed(AppRouteNames.dashboard);
      },
    },
  );
}
