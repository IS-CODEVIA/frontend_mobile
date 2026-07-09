import 'package:flutter/material.dart';

import '../../../../shared/responsive/responsive_utils.dart';

class RoleSelectorButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleSelectorButton({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 10 : 12),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.secondary.withValues(alpha: 0.05)
                : Colors.transparent,
            border: Border.all(
              color: isSelected
                  ? colorScheme.secondary
                  : colorScheme.outlineVariant,
              width: isSelected ? 2.0 : 1.0,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isSmallScreen ? 18 : 20,
                color:
                    isSelected ? colorScheme.secondary : colorScheme.outline,
              ),
              SizedBox(width: isSmallScreen ? 6 : 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: responsiveFontSize(context, 14),
                  color:
                      isSelected ? colorScheme.secondary : colorScheme.outline,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}