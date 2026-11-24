import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libreria/app/app.dart';

void main() {
  testWidgets('El inicio muestra las secciones principales', (tester) async {
    await tester.pumpWidget(const LibreriaApp());
    await tester.pumpAndSettle();

    expect(find.text('Librería Central Winterbach'), findsOneWidget);
    expect(find.text('Catálogo'), findsOneWidget);
    expect(find.text('Convenios con escuelas'), findsOneWidget);
  });

  testWidgets('Cada sección abre y carga sin errores', (tester) async {
    // Pantalla alta como la de un celular: las listas construyen solo lo visible.
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const LibreriaApp());
    await tester.pumpAndSettle();

    for (final (tarjeta, contenido) in [
      ('Catálogo', 'Rayuela'),
      ('Convenios con escuelas', 'Colegio San José'),
      ('Información de la librería', 'Horarios de atención'),
      ('Nuestra historia', 'Librería Central Winterbach'),
    ]) {
      await tester.tap(find.text(tarjeta));
      await tester.pumpAndSettle();
      expect(find.text(contenido), findsWidgets, reason: tarjeta);
      expect(tester.takeException(), isNull, reason: tarjeta);

      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pumpAndSettle();
    }
  });
}
