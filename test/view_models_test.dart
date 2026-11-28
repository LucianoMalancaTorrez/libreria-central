import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:libreria/data/repositories/asset_libro_repository.dart';
import 'package:libreria/data/repositories/in_memory_escuela_repository.dart';
import 'package:libreria/data/repositories/in_memory_horarios_repository.dart';
import 'package:libreria/data/services/sin_push.dart';
import 'package:libreria/domain/logic/club_lectura.dart';
import 'package:libreria/domain/logic/horario_comercial.dart';
import 'package:libreria/domain/logic/recordatorio.dart';
import 'package:libreria/domain/models/horario_atencion.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/domain/services/avisos.dart';
import 'package:libreria/presentation/admin/viewmodels/acceso_view_model.dart';
import 'package:libreria/presentation/ajustes/viewmodels/ajustes_view_model.dart';
import 'package:libreria/presentation/catalogo/viewmodels/catalogo_view_model.dart';
import 'package:libreria/presentation/escuelas/viewmodels/escuelas_view_model.dart';
import 'package:libreria/presentation/eventos/viewmodels/club_view_model.dart';
import 'package:libreria/presentation/favoritos/viewmodels/favoritos_view_model.dart';
import 'package:libreria/presentation/informacion/viewmodels/informacion_view_model.dart';

import 'fakes.dart';

void main() {
  group('CatalogoViewModel', () {
    test('pasa por cargando y termina con los libros', () async {
      final viewModel = CatalogoViewModel(LibrosFalsos());
      final estados = <bool>[];
      viewModel.addListener(() => estados.add(viewModel.cargando));

      await viewModel.cargar();

      expect(estados, [true, false]);
      expect(viewModel.libros, hasLength(3));
      expect(viewModel.error, isNull);
    });

    test('busca sin tildes y filtra por género', () async {
      final viewModel = CatalogoViewModel(LibrosFalsos());
      await viewModel.cargar();

      viewModel.buscar('garcia marquez');
      expect(viewModel.libros.single.titulo, 'Cien Años de Soledad');

      viewModel.buscar('');
      viewModel.filtrarGenero('Cuento');
      expect(viewModel.libros.single.titulo, 'Ficciones');
    });

    test('arma la lista con un encabezado por género', () async {
      final viewModel = CatalogoViewModel(LibrosFalsos());
      await viewModel.cargar();

      expect(viewModel.filas.whereType<FilaEncabezado>().map((f) => f.genero), [
        'Cuento',
        'Novela',
      ]);
    });

    test('ordena por título y por autor', () async {
      final viewModel = CatalogoViewModel(LibrosFalsos());
      await viewModel.cargar();

      viewModel.ordenar(OrdenCatalogo.titulo);
      expect(viewModel.libros.first.titulo, 'Cien Años de Soledad');

      viewModel.ordenar(OrdenCatalogo.autor);
      expect(viewModel.libros.first.autor, 'Gabriel García Márquez');
    });

    test('si falla, guarda el error y deja de cargar', () async {
      final viewModel = CatalogoViewModel(LibrosFalsos(falla: true));

      await viewModel.cargar();

      expect(viewModel.cargando, isFalse);
      expect(viewModel.error, 'No se pudo cargar el catálogo.');
    });

    test('no notifica si la pantalla ya se cerró', () async {
      final viewModel = CatalogoViewModel(LibrosFalsos());
      final carga = viewModel.cargar();

      viewModel.dispose();

      await expectLater(carga, completes);
    });
  });

  group('FavoritosViewModel', () {
    test('guarda, ordena y se recupera al volver a abrir', () async {
      final preferencias = PreferenciasEnMemoria();
      final favoritos = FavoritosViewModel(preferencias)
        ..alternar('1')
        ..alternar('2')
        ..reordenar(['1', '2'], 1, 0);

      final otraSesion = FavoritosViewModel(preferencias);
      await otraSesion.cargar();

      expect(favoritos.ids, ['2', '1']);
      expect(otraSesion.ids, ['2', '1']);
    });

    test('reordenar ignora los favoritos que ya no existen', () {
      final favoritos = FavoritosViewModel(PreferenciasEnMemoria())
        ..alternar('borrado')
        ..alternar('a')
        ..alternar('b');

      // En pantalla solo se ven "a" y "b"; se sube "b".
      favoritos.reordenar(['a', 'b'], 1, 0);

      expect(favoritos.ids, ['borrado', 'b', 'a']);
    });

    test('quitar permite deshacer en la misma posición', () {
      final favoritos = FavoritosViewModel(PreferenciasEnMemoria())
        ..alternar('1')
        ..alternar('2')
        ..alternar('3');

      final posicion = favoritos.quitar('2');
      favoritos.insertar(posicion, '2');

      expect(favoritos.ids, ['1', '2', '3']);
    });
  });

  group('Avisos del club', () {
    test('sin permiso no se activan', () async {
      final avisos = AvisosFalsos(ResultadoPermiso.denegado);
      final ajustes = AjustesViewModel(
        PreferenciasEnMemoria(),
        avisos,
        const SinPush(),
      );

      await ajustes.cambiarAvisosClub(true);

      expect(ajustes.avisosClub, isFalse);
      expect(avisos.semanal, isNull);
    });

    test('con permiso programa el aviso semanal', () async {
      final avisos = AvisosFalsos();
      final ajustes = AjustesViewModel(
        PreferenciasEnMemoria(),
        avisos,
        const SinPush(),
      );

      await ajustes.cambiarAvisosClub(true);

      expect(ajustes.avisosClub, isTrue);
      expect(avisos.semanal, isTrue);
    });
  });

  test(
    'refrescar el catálogo no muestra "cargando" ni borra lo que hay',
    () async {
      final catalogo = CatalogoViewModel(LibrosFalsos());
      await catalogo.cargar();
      final estados = <bool>[];
      catalogo.addListener(() => estados.add(catalogo.cargando));

      await catalogo.refrescar();

      expect(estados, isNot(contains(true)));
      expect(catalogo.libros, isNotEmpty);
    },
  );

  group('Aviso semanal', () {
    test('cae el próximo jueves a las 10', () {
      expect(
        proximoAvisoSemanal(DateTime(2026, 11, 28, 12)),
        DateTime(2026, 12, 3, 10),
      );
    });

    test('un jueves después de las 10 pasa a la semana siguiente', () {
      expect(
        proximoAvisoSemanal(DateTime(2026, 12, 3, 10)),
        DateTime(2026, 12, 10, 10),
      );
    });

    test('no duplica el recordatorio puntual si ya es semanal', () async {
      final avisos = AvisosFalsos();

      final resultado = await ClubViewModel(avisos)
          .recordar(DateTime(2026, 12, 3), yaSemanal: true);

      expect(resultado, ResultadoRecordatorio.yaSemanal);
      expect(avisos.programado, isNull);
    });
  });

  group('Horario del local', () {
    const h = Horarios.habituales;

    // 24/11/2026 es martes (temporada de verano).
    test('abierto a la mañana', () {
      final estado = estadoDelLocal(DateTime(2026, 11, 24, 10), h);
      expect(estado.abierto, isTrue);
      expect(estado.detalle, 'Cierra a las 13:00');
    });

    test('la tarde de verano abre 17:30 y la de invierno 16:30', () {
      expect(
        estadoDelLocal(DateTime(2026, 11, 24, 17), h).detalle,
        'Abre hoy a las 17:30',
      );
      expect(estadoDelLocal(DateTime(2026, 6, 23, 17), h).abierto, isTrue);
    });

    test('el sábado a la noche y el domingo avisan que abre el lunes', () {
      expect(
        estadoDelLocal(DateTime(2026, 11, 28, 22), h).detalle,
        'Abre el lunes a las 9:00',
      );
      expect(
        estadoDelLocal(DateTime(2026, 11, 29, 10), h).detalle,
        'Abre mañana a las 9:00',
      );
    });
  });

  test('El club de lectura cae siempre en jueves', () {
    final fechas = proximosEncuentros(DateTime(2026, 11, 24));
    expect(fechas.first, DateTime(2026, 11, 26));
    expect(fechas.every(esDiaDeClub), isTrue);
  });

  test('El catálogo de ejemplo tiene unos 100 libros con id único', () {
    final libros = parsearLibros(
      File('assets/data/libros.json').readAsStringSync(),
    );
    expect(libros.length, greaterThanOrEqualTo(90));
    expect({for (final l in libros) l.id}.length, libros.length);
  });

  test('EscuelasViewModel muestra solo las dos escuelas confirmadas', () async {
    final viewModel = EscuelasViewModel(InMemoryEscuelaRepository());

    await viewModel.cargar();

    expect(viewModel.escuelas.map((e) => e.nombre), [
      'Escuela Sarmiento',
      'Colegio San José',
    ]);
  });

  test('InformacionViewModel carga horarios y contacto', () async {
    final viewModel = InformacionViewModel(InMemoryHorariosRepository());

    await viewModel.cargar();

    expect(viewModel.horarios.verano.texto, contains('17:30'));
    expect(viewModel.info, isNotNull);
  });

  test('Un libro se guarda y se vuelve a leer igual', () {
    const libro = Libro(id: '7', titulo: 'T', autor: 'A', genero: 'Novela');

    final copia = Libro.fromJson(libro.toJson(), id: libro.id);

    expect(copia.toJson(), libro.toJson());
    expect(copia.id, '7');
  });

  group('Acceso al panel', () {
    test('una cuenta sin habilitar no entra', () async {
      final acceso = AccesoViewModel(AuthFalso(admin: false));

      await acceso.ingresar('a@b.com', 'x');
      await pumpEventQueue();

      expect(acceso.usuario, isNotNull);
      expect(acceso.habilitado, isFalse);
    });

    test('una clave mala deja un mensaje de error', () async {
      final acceso = AccesoViewModel(AuthFalso(falla: true));

      await acceso.ingresar('a@b.com', 'x');

      expect(acceso.usuario, isNull);
      expect(acceso.error, contains('No se pudo ingresar'));
    });
  });
}
