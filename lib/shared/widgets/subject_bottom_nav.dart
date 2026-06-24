import 'package:flutter/material.dart';

class SubjectBottomNav extends StatelessWidget {
  const SubjectBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final itemStyle = textTheme.labelLarge?.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              // Píldora Turquesa (Primary)
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _NavItem(text: 'Avisos', style: itemStyle, onTap: () {}),
                      _NavItem(text: 'Transcriptor', style: itemStyle, onTap: () {}),
                      _NavItem(text: 'Material', style: itemStyle, onTap: () {}),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Botón Azul Oscuro (Secondary)
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text('Personas', style: itemStyle),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final VoidCallback onTap;

  const _NavItem({required this.text, required this.style, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        child: Text(text, style: style),
      ),
    );
  }
}