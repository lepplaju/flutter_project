import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  Color? color;

  CustomDialog({required this.title, required this.content, this.color});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: color ?? Colors.white,
      key: ValueKey('custom_dialog'),
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
  void showCustomDialog(BuildContext context, bool? correct) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (correct == null) {
          return CustomDialog(
            title: 'Error!',
            content: 'Please select an answer!',
          );
        }
        return correct
            ? CustomDialog(
                title: 'Correct!',
                content: 'You can move on to the next question',
                color: Colors.green,
              )
            : CustomDialog(
                title: 'Wrong!',
                content: 'Try again',
                color: Colors.red,
              );
      },
    );
  }
}
