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
  return showGenericPopup(
    context: context,
    title: 'You Failed Today',
    content: 'You are a disgrace to Humanity. You failed today, but you can try again tomorrow.',
    optionsBuilder: () => {
      'OK': () {
        ref.read(habitProvider.notifier).recordFailure(); 
        context.goNamed(AppRouteNames.dashboard);
      },
    },
  );
}
