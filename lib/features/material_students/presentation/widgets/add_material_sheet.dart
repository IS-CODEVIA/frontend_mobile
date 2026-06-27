import 'package:flutter/material.dart';

class AddMaterialSheet {
  static void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Solo el profesor puede agregar materiales')),
    );
  }
}
