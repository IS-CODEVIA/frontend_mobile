import 'package:flutter/material.dart';

import '../../../../shared/responsive/responsive_utils.dart';

class ProfilePicturePicker extends StatelessWidget {
  final VoidCallback onTap;
  final double size;

  const ProfilePicturePicker({
    super.key,
    required this.onTap,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    final avatarSize = responsiveValue<double>(
      context,
      mobile: isSmallScreen ? 80 : size,
      tablet: 120,
      desktop: 140,
    );

    return Center(
      child: Stack(
        children: [
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.surfaceContainerHighest,
              border: Border.all(
                color: colorScheme.secondary,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.person,
              size: avatarSize * 0.5,
              color: colorScheme.outline,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.all(isSmallScreen ? 4 : 6),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.onPrimary, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: isSmallScreen ? 14 : 16,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}