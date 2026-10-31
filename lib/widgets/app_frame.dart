import 'package:flutter/material.dart';

class AppFrame extends StatelessWidget {
  const AppFrame({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) return child;
        return ColoredBox(
          color: const Color(0xFF020612),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                radius: 1.2,
                colors: [Color(0xFF12275A), Color(0xFF030714)],
              ),
            ),
            child: Center(
              child: Container(
                width: 430,
                height: constraints.maxHeight - 28,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(44),
                  border: Border.all(color: const Color(0xFF315A9A), width: 2),
                  boxShadow: const [
                    BoxShadow(color: Colors.black87, blurRadius: 30),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(37),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
