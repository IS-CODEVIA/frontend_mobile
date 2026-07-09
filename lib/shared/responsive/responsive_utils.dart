import 'package:flutter/material.dart';

double sw(BuildContext context, double percentage) =>
    MediaQuery.of(context).size.width * percentage;

double sh(BuildContext context, double percentage) =>
    MediaQuery.of(context).size.height * percentage;

double shMax(BuildContext context, double value) {
  final h = MediaQuery.of(context).size.height;
  return h < value ? h : value;
}

double swMax(BuildContext context, double value) {
  final w = MediaQuery.of(context).size.width;
  return w < value ? w : value;
}

double responsiveFontSize(BuildContext context, double baseSize) {
  final width = MediaQuery.of(context).size.width;
  if (width < 360) return baseSize * 0.85;
  if (width > 600) return baseSize * 1.1;
  return baseSize;
}

T responsiveValue<T>(BuildContext context,
    {required T mobile, T? tablet, T? desktop}) {
  final width = MediaQuery.of(context).size.width;
  if (width >= 900 && desktop != null) return desktop;
  if (width >= 600 && tablet != null) return tablet;
  return mobile;
}

double horizontalPadding(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < 360) return 20;
  if (width > 600) return 48;
  return 32;
}