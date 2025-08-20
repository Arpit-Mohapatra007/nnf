import 'package:flutter/material.dart';

typedef DialogOptionBuilder = Map<String, VoidCallback> Function();

Future showGenericPopup({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
}){
  final options = optionsBuilder();
  return showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTitle){
          final value = options[optionTitle];
          return TextButton(
            onPressed: (){
              Navigator.of(context).pop();
              if(value != null){
                value(); 
              }
            },
            child: Text(optionTitle),
          );
        }).toList(),
      );
    }
  );
}
