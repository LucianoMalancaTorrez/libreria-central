import 'package:flutter_test/flutter_test.dart';
import 'package:libreria/app/app.dart';
import 'package:libreria/app/coordinador_avisos.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/domain/services/avisos.dart';

import 'fakes.dart';

void main() {
  test('solo acepta destinos conocidos', () {
    expect(destinoValido('catalogo'), destinoCatalogo);
    expect(destinoValido('otra cosa'), isNull);
    expect(destinoValido(null), isNull);
  });

  test('con la app abierta, el push se muestra como aviso local', () async {
    final avisos = AvisosFalsos();
    final push = PushFalso();
    final coordinador = CoordinadorAvisos(avisos, push, abrir: (_) {})
      ..iniciar();

    push.llega(destinoCatalogo);
    await Future<void>.delayed(Duration.zero);

    expect(avisos.mostrados, [(destino: destinoCatalogo, novedad: true)]);
    coordinador.dispose();
  });

  for (final (destino, texto) in [
    (destinoCatalogo, 'Buscar por título o autor...'),
    (destinoHorarios, 'Horarios de atención'),
  ]) {
    testWidgets('tocar un aviso de $destino abre esa pantalla', (tester) async {
      final avisos = AvisosFalsos();
      await tester.pumpWidget(
        LibreriaApp(
          servicios: Servicios(
            libros: LibrosFalsos(),
            preferencias: PreferenciasEnMemoria(),
            avisos: avisos,
            conexion: () => Stream.value(true),
          ),
        ),
      );
      await tester.pumpAndSettle();

      avisos.tocar(destino);
      await tester.pumpAndSettle();

      expect(find.text(texto), findsOneWidget);
    });
  }
}
