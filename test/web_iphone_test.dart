import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/presentation/ajustes/instalar_screen.dart';
import 'package:libreria/presentation/eventos/widgets/pestana_avisos.dart';

import 'fakes.dart';

class _SinSegundoPlano extends AvisosFalsos {
  @override
  bool get soportaSegundoPlano => false;
}

void main() {
  testWidgets('sin segundo plano se explica en vez de ofrecer el aviso', (
    tester,
  ) async {
    await tester.pumpWidget(
      Dependencias(
        servicios: Servicios(
          preferencias: PreferenciasEnMemoria(),
          avisos: _SinSegundoPlano(),
        ),
        child: const MaterialApp(home: Scaffold(body: PestanaAvisos())),
      ),
    );

    expect(find.text('Acá no hay avisos'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsNothing);
  });

  testWidgets('explica cómo instalar en iPhone', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: InstalarScreen()));

    expect(find.text('En iPhone'), findsOneWidget);
    expect(find.textContaining('Safari'), findsOneWidget);
  });
}
