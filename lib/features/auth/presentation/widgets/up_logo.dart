import 'package:flutter/material.dart';

class UpLogo extends StatelessWidget {
  const UpLogo({super.key});

  @override
  Widget build(BuildContext context) {
    

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        
        Image.asset('assets/images/up_logo_1.png', height: 180), 
        const SizedBox(height: 11),
       
        const SizedBox(height: 4),
      ],
    );
  }
}