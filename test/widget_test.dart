// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:libreria/main.dart';

void main() {
  testWidgets('Carga inicial de la app de Librería Central', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verifica que se muestre el título y la opción de convenios con escuelas
    expect(find.text('Librería Central Winterbach'), findsOneWidget);
    expect(find.text('Catálogo'), findsOneWidget);
    expect(find.text('Convenios con escuelas'), findsOneWidget);
  });
}
