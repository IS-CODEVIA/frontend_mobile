import 'package:flutter/material.dart';

class ComenzarButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ComenzarButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: colorScheme.onSecondary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
      ),
      child: Text(
        'Comenzar',
        style: textTheme.labelLarge?.copyWith(
          color: colorScheme.onSecondary,
        ),
      ),
    );
  }
}
