import 'package:flutter/material.dart';
import 'dart:io';

typedef DialogOptionBuilder = Map<String, VoidCallback> Function();

Future showGenericPopup({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
  String? imagePath, // Added image support
}) {
  final options = optionsBuilder();
  return showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Show image if path is provided
            if (imagePath != null && imagePath.isNotEmpty)
              Container(
                height: 150,
                width: 150,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: options.keys.map((optionTitle) {
          final value = options[optionTitle];
          return ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (value != null) {
                value();
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 40),
            ),
            child: Text(optionTitle),
          );
        }).toList(),
      );
    },
  );
}
