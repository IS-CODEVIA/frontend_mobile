import 'package:flutter/material.dart';

class NewNoticeDialog {
  static void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Solo el profesor puede crear avisos')),
    );
  }
}
