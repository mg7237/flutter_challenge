import 'package:flutter/material.dart';

enum ConfirmAction { CANCEL, OK }

class AlertDialogs {
  final String title;
  final String message;
  AlertDialogs({this.title, this.message});

  Future<String> asyncConfirmDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop('CANCEL');
              },
            ),
            FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop('OK');
              },
            )
          ],
        );
      },
    );
  }

  Future<void> asyncAckAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(this.title),
          content: Text(this.message),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
