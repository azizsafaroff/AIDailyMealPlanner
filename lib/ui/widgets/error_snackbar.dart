import 'package:flutter/material.dart';

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFD64545),
        behavior: SnackBarBehavior.floating,
      ),
    );
}
