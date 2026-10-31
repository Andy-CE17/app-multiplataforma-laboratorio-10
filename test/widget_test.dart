import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio_9_demo/app.dart';

void main() {
  testWidgets('navega desde Login hasta las secciones principales', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LaboratoryApp());
    await tester.pumpAndSettle();

    expect(find.text('N▶VA'), findsOneWidget);
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Hola,'), findsOneWidget);
    expect(find.text('Tendencias'), findsOneWidget);

    await tester.tap(find.text('Categorías'));
    await tester.pumpAndSettle();
    expect(find.text('Películas de Acción'), findsOneWidget);

    await tester.tap(find.text('Mi lista'));
    await tester.pumpAndSettle();
    expect(find.text('Mi lista'), findsWidgets);

    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    expect(find.text('NOVA Premium'), findsOneWidget);

    await tester.tap(find.text('Editar perfil'));
    await tester.pumpAndSettle();
    expect(find.text('Cambiar foto'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Andy Campos');
    await tester.enterText(fields.at(1), 'andy@nova.com');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Andy Campos'), findsOneWidget);
    expect(find.text('andy@nova.com'), findsOneWidget);
  });
}
