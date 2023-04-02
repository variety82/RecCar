import 'package:flutter/material.dart';

export 'package:flutter/material.dart';

void showConfirmationDialog(BuildContext context, Function func, String title, String content, String yes_text, String no_text, {dynamic data}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text(yes_text),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          TextButton(
            child: Text(no_text),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  ).then((value) {
    if (value == true) {
      if (data != null) {
        func(data);
      }
    } else if (value == false) {
      // 그냥 나가기~
    }
  });
}

