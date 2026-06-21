import 'package:flutter/material.dart';

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

    return Center(
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
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
              size: size * 0.5,
              color: colorScheme.outline,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.onPrimary, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 16,
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