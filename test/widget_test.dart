import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio_9_demo/app.dart';

void main() {
  testWidgets('muestra la lista de imágenes locales', (tester) async {
    await tester.pumpWidget(const LaboratoryApp());

    expect(find.text('Lista de Imágenes Locales'), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
  });
}
