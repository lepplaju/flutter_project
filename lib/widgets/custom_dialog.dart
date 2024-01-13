import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;

  CustomDialog({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}

class DialogController {
  void showCustomDialog(BuildContext context, bool correct) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return correct
            ? CustomDialog(
                title: 'Correct!',
                content: 'You can move on to the next question',
              )
            : CustomDialog(
                title: 'Wrong!',
                content: 'Try again',
              );
      },
    );
  }
}
