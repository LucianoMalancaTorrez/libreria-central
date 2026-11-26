import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libreria/app/app.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/data/repositories/in_memory_horarios_repository.dart';
import 'package:libreria/domain/models/horario_atencion.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/domain/repositories/horarios_repository.dart';
import 'package:libreria/domain/repositories/libro_repository.dart';
import 'package:libreria/presentation/admin/viewmodels/horarios_admin_view_model.dart';
import 'package:libreria/presentation/admin/viewmodels/libros_admin_view_model.dart';

import 'fakes.dart';

class CatalogoAdminFalso implements CatalogoAdminRepository {
  CatalogoAdminFalso({this.falla = false});
  final bool falla;
  final importados = <Libro>[];

  @override
  Stream<List<Libro>> observarPublicados() => falla
      ? Stream.error(Exception('sin permiso'))
      : Stream.value(librosDePrueba);
  @override
  Future<void> guardar(Libro libro) async {}
  @override
  Future<void> eliminar(String id) async {
    if (falla) throw Exception('sin permiso');
  }

  @override
  Future<void> importar(List<Libro> libros) async => importados.addAll(libros);
}

class HorariosAdminFalso implements HorariosAdminRepository {
  Horarios? guardados;

  @override
  Future<void> guardarHorarios(Horarios horarios) async => guardados = horarios;
}

void main() {
  group('Panel: libros', () {
    test('carga lo publicado e importa el ejemplo', () async {
      final catalogo = CatalogoAdminFalso();
      final viewModel = LibrosAdminViewModel(catalogo, LibrosFalsos());

      await viewModel.cargar();
      final mensaje = await viewModel.importar();

      expect(viewModel.libros, hasLength(3));
      expect(catalogo.importados, hasLength(3));
      expect(mensaje, contains('cargado'));
      expect(viewModel.importando, isFalse);
    });

    test('un error se informa en lugar de quedar cargando', () async {
      final viewModel = LibrosAdminViewModel(
        CatalogoAdminFalso(falla: true),
        LibrosFalsos(),
      );

      await viewModel.cargar();

      expect(viewModel.cargando, isFalse);
      expect(viewModel.error, isNotNull);
      expect(
        await viewModel.eliminar(librosDePrueba.first),
        'No se pudo borrar.',
      );
    });
  });

  group('Panel: horarios', () {
    test('no guarda horas desordenadas', () async {
      final escritura = HorariosAdminFalso();
      final viewModel = HorariosAdminViewModel(
        InMemoryHorariosRepository(),
        escritura,
      );
      await viewModel.cargar();

      viewModel.cambiar(Temporada.verano, 0, 23 * 60);

      expect(await viewModel.guardar(), 'Revisá el orden de las horas.');
      expect(escritura.guardados, isNull);
    });

    test('guarda el cambio', () async {
      final escritura = HorariosAdminFalso();
      final viewModel = HorariosAdminViewModel(
        InMemoryHorariosRepository(),
        escritura,
      );
      await viewModel.cargar();

      viewModel.cambiar(Temporada.invierno, 0, 8 * 60);

      expect(await viewModel.guardar(), 'Horarios guardados');
      expect(escritura.guardados!.invierno.manana.desde, 8 * 60);
    });
  });

  testWidgets('la administradora ingresa y ve las dos pestañas', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(420, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      LibreriaApp(
        servicios: Servicios(
          libros: LibrosFalsos(),
          preferencias: PreferenciasEnMemoria(),
          avisos: AvisosFalsos(),
          conexion: () => Stream.value(true),
          administracion: Administracion(
            auth: AuthFalso(),
            catalogo: CatalogoAdminFalso(),
            horarios: HorariosAdminFalso(),
            catalogoDeEjemplo: LibrosFalsos(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Más').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Administración'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'a@b.com');
    await tester.enterText(find.byType(TextFormField).last, 'x');
    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();

    expect(find.text('Cargar catálogo de ejemplo'), findsOneWidget);
    await tester.tap(find.text('Horarios'));
    await tester.pumpAndSettle();
    expect(find.text('Guardar horarios'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
