import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:libreria/app/app.dart';

/// Recorrido completo en un dispositivo real:
/// flutter test integration_test
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('guardar un libro y verlo en Mi lista', (tester) async {
    await tester.pumpWidget(const LibreriaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Catálogo').last);
    await tester.pumpAndSettle();
    final corazon = find.byTooltip('Agregar a mi lista');
    // Si quedó guardado de una corrida anterior, ya está en la lista.
    if (corazon.evaluate().isNotEmpty) {
      await tester.tap(corazon.first);
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Mi lista').last);
    await tester.pumpAndSettle();

    expect(find.byType(Dismissible), findsWidgets);
  });
}
