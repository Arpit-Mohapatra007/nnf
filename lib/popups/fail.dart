import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nnf/popups/genereic_popup.dart';
import 'package:nnf/routes/route_names.dart';

Future<void> showFailPopup({
  required BuildContext context,
  }) {
  return showGenericPopup(
    context: context,
    title: 'Failed',
    content: 'You are a disgrace to humanity',
    optionsBuilder: () => {
      'OK': ()=>context.goNamed(AppRouteNames.dashboard),
    },
  );
}