import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

class NovaLogo extends StatelessWidget {
  const NovaLogo({this.large = false, super.key});

  final bool large;

  @override
  Widget build(BuildContext context) {
    final size = large ? 58.0 : 30.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, NovaColors.cyan, NovaColors.violet],
          ).createShader(bounds),
          child: Text(
            'N▶VA',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: size,
              fontWeight: FontWeight.w900,
              letterSpacing: large ? 4 : 2,
              height: .9,
              shadows: const [Shadow(color: NovaColors.cyan, blurRadius: 18)],
            ),
          ),
        ),
        Text(
          'S T R E A M',
          style: GoogleFonts.rajdhani(
            color: const Color(0xFF8FB9FF),
            fontSize: large ? 17 : 10,
            fontWeight: FontWeight.w600,
            letterSpacing: large ? 7 : 4,
          ),
        ),
      ],
    );
  }
}
