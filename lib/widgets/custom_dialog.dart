import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final Color? color;

  const CustomDialog(
      {super.key, required this.title, required this.content, this.color});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: color ?? Colors.white,
      key: const ValueKey('custom_dialog'),
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('OK'),
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
          return const CustomDialog(
            title: 'Error!',
            content: 'Please select an answer!',
          );
        }
        return correct
            ? const CustomDialog(
                title: 'Correct!',
                content: 'You can move on to the next question',
                color: Colors.green,
              )
            : const CustomDialog(
                title: 'Wrong!',
                content: 'Try again',
                color: Colors.red,
              );
      },
    );
  }
}
