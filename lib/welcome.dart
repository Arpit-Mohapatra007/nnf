import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nnf/popups/fail.dart';
import 'package:nnf/popups/success.dart';

class Welcome extends ConsumerWidget {
  const Welcome({super.key});

  @override 
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Did you fapped today buddy?',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showSuccessPopup(context: context, ref: ref);
                  },
                  child: const Text('Yes', 
                  style: TextStyle(
                    fontSize: 18
                    ),
                  )
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    showFailPopup(context: context, ref: ref);
                  },
                  child: const Text('No',
                  style: TextStyle(
                    fontSize: 18
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}