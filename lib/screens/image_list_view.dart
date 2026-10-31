import 'package:flutter/material.dart';

class ImageListView extends StatelessWidget {
  const ImageListView({super.key});

  // Lista de rutas de imágenes locales.
  static const List<String> imagePaths = [
    'prueba/images/logo.png',
    'prueba/images/logo2.png',
    'prueba/images/logo3.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Imágenes Locales')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                imagePaths[index],
                height: 420,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
