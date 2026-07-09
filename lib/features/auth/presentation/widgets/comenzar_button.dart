import 'package:flutter/material.dart';

import '../../../../shared/responsive/responsive_utils.dart';

class ComenzarButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ComenzarButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: colorScheme.onSecondary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 24 : 32,
          vertical: isSmallScreen ? 10 : 14,
        ),
      ),
      child: Text(
        'Comenzar',
        style: textTheme.labelLarge?.copyWith(
          color: colorScheme.onSecondary,
          fontSize: responsiveFontSize(context, 14),
        ),
      ),
    );
  }
}