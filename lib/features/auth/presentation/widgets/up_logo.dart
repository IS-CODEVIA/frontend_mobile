import 'package:flutter/material.dart';

import '../../../../shared/responsive/responsive_utils.dart';

class UpLogo extends StatelessWidget {
  const UpLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final logoSize = responsiveValue<double>(
      context,
      mobile: 140,
      tablet: 180,
      desktop: 200,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/up_logo_1.png', height: logoSize),
      ],
    );
  }
}