import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libreria/app/app.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/services/avisos.dart';
import 'package:libreria/core/theme/app_theme.dart';
import 'package:libreria/data/local/libros_dao.dart';
import 'package:libreria/data/repositories/libro_repository_con_copia_local.dart';
import 'package:libreria/domain/logic/recordatorio.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/domain/services/fotos.dart';
import 'package:libreria/presentation/admin/viewmodels/foto_view_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'fakes.dart';

/// SQLite en memoria, dentro de la PC.
Future<LibrosDao> daoEnMemoria() async {
  sqfliteFfiInit();
  final dao = LibrosDao(
    () => databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        singleInstance: false,
        onCreate: (db, _) => db.execute(LibrosDao.sqlCrear),
      ),
    ),
  );
  addTearDown(dao.cerrar);
  return dao;
}

void main() {
  group('SQLite', () {
    test('guarda y reemplaza la copia del catálogo', () async {
      final dao = await daoEnMemoria();

      await dao.reemplazarTodos(librosDePrueba);
      await dao.reemplazarTodos([librosDePrueba.first]);

      expect((await dao.todos()).single.titulo, 'Rayuela');
    });

    test('un texto malicioso se busca como texto, no como SQL', () async {
      final dao = await daoEnMemoria();
      await dao.reemplazarTodos(librosDePrueba);

      expect(await dao.buscarPorTitulo("x' OR '1'='1"), isEmpty);
    });

    test('muestra la copia aunque la nube falle', () async {
      final dao = await daoEnMemoria();
      await dao.reemplazarTodos(librosDePrueba);
      final repositorio = LibroRepositoryConCopiaLocal(
        LibrosFalsos(falla: true),
        dao,
      );

      final List<Libro> primero = await repositorio.observarLibros().first;

      expect(primero, hasLength(3));
    });
  });

  group('Foto de la tapa', () {
    test('cancelar no es un error y conserva la anterior', () async {
      final borrador = BorradorEnMemoria();
      final fotos = FotoViewModel(
        FuenteFalsa([
          Uint8List.fromList([1, 2]),
          null,
        ]),
        borrador,
        clave: '1',
      );

      await fotos.elegir(OrigenFoto.galeria);
      final anterior = fotos.foto;
      await fotos.elegir(OrigenFoto.camara);

      expect(fotos.foto, anterior);
      expect(fotos.error, isNull);
      expect(borrador.datos, contains('1'));
    });

    test('recupera el borrador si la app se cerró', () async {
      final borrador = BorradorEnMemoria()
        ..datos['1'] = Uint8List.fromList([7]);
      final fotos = FotoViewModel(FuenteFalsa([]), borrador, clave: '1');

      await fotos.recuperar();

      expect(fotos.foto, isNotEmpty);
    });

    test('rechaza una imagen demasiado grande', () async {
      final fotos = FotoViewModel(
        FuenteFalsa([Uint8List(FotoViewModel.maximoBytes + 1)]),
        BorradorEnMemoria(),
        clave: '1',
      );

      await fotos.elegir(OrigenFoto.galeria);

      expect(fotos.foto, isEmpty);
      expect(fotos.error, isNotNull);
    });
  });

  test('el recordatorio sale a las 10 y no si ya pasó', () {
    final jueves = DateTime(2026, 11, 26);

    expect(
      horaDelRecordatorio(jueves, DateTime(2026, 11, 25)),
      DateTime(2026, 11, 26, 10),
    );
    expect(horaDelRecordatorio(jueves, DateTime(2026, 11, 26, 11)), isNull);
  });

  testWidgets('tocar un aviso abre el club de lectura', (tester) async {
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

    avisos.tocar(destinoClub);
    await tester.pumpAndSettle();

    expect(find.text('Encuentros'), findsOneWidget);
  });

  testWidgets('con el sistema en modo oscuro usa el tema oscuro', (
    tester,
  ) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    await tester.pumpWidget(LibreriaApp(servicios: serviciosDePrueba()));
    await tester.pumpAndSettle();

    final contexto = tester.element(find.text('Librería Central Winterbach'));
    expect(Theme.of(contexto).brightness, Brightness.dark);
    expect(tester.takeException(), isNull);
  });

  test('el indicador de navegación usa la paleta en los dos temas', () {
    expect(AppTheme.light.colorScheme.secondaryContainer, Colores.claro.brass);
    expect(AppTheme.dark.colorScheme.secondaryContainer, Colores.oscuro.brass);
  });
}
