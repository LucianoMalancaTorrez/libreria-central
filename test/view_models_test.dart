import 'package:flutter_test/flutter_test.dart';
import 'package:libreria/data/repositories/in_memory_escuela_repository.dart';
import 'package:libreria/data/repositories/in_memory_horarios_repository.dart';
import 'package:libreria/data/repositories/in_memory_libro_repository.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/domain/repositories/libro_repository.dart';
import 'package:libreria/presentation/catalogo/viewmodels/catalogo_view_model.dart';
import 'package:libreria/presentation/escuelas/viewmodels/escuelas_view_model.dart';
import 'package:libreria/presentation/informacion/viewmodels/informacion_view_model.dart';

/// Repositorio falso que simula un corte de conexión.
class _RepositorioSinConexion implements LibroRepository {
  @override
  Future<List<Libro>> getLibros() async => throw Exception('Sin conexión');
}

void main() {
  group('CatalogoViewModel', () {
    test('pasa por cargando y termina con los libros', () async {
      final viewModel = CatalogoViewModel(InMemoryLibroRepository());
      final estados = <bool>[];
      viewModel.addListener(() => estados.add(viewModel.cargando));

      await viewModel.cargar();

      expect(estados, [true, false]);
      expect(viewModel.libros, isNotEmpty);
      expect(viewModel.error, isNull);
    });

    test('busca sin distinguir mayúsculas ni tildes', () async {
      final viewModel = CatalogoViewModel(InMemoryLibroRepository());
      await viewModel.cargar();

      viewModel.buscar('garcia marquez');

      expect(viewModel.libros.single.titulo, 'Cien Años de Soledad');
    });

    test('si falla, guarda el error y deja de cargar', () async {
      final viewModel = CatalogoViewModel(_RepositorioSinConexion());

      await viewModel.cargar();

      expect(viewModel.cargando, isFalse);
      expect(viewModel.error, 'No se pudo cargar el catálogo.');
    });

    test('no notifica si la pantalla ya se cerró', () async {
      final viewModel = CatalogoViewModel(InMemoryLibroRepository());
      final carga = viewModel.cargar();

      viewModel.dispose();

      await expectLater(carga, completes);
    });
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

    expect(viewModel.horarios, hasLength(2));
    expect(viewModel.info, isNotNull);
  });
}
