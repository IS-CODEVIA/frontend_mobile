import 'package:flutter/material.dart';

import '../../../../shared/responsive/responsive_utils.dart';

class UpLogo extends StatelessWidget {
  const UpLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final logoSize = responsiveValue<double>(
      context,
      mobile: 220,
      tablet: 260,
      desktop: 300,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/up_logo_1.png', height: logoSize),
      ],
    );
  }
}