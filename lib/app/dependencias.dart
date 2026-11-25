import 'package:flutter/widgets.dart';
import 'package:libreria/core/services/avisos.dart';
import 'package:libreria/core/services/conexion.dart';
import 'package:libreria/core/services/push.dart';
import 'package:libreria/data/repositories/asset_libro_repository.dart';
import 'package:libreria/data/repositories/in_memory_escuela_repository.dart';
import 'package:libreria/data/repositories/in_memory_horarios_repository.dart';
import 'package:libreria/data/repositories/shared_preferencias_repository.dart';
import 'package:libreria/data/services/archivo_borrador_foto.dart';
import 'package:libreria/data/services/image_picker_fuente.dart';
import 'package:libreria/data/services/open_library_service.dart';
import 'package:libreria/domain/repositories/escuela_repository.dart';
import 'package:libreria/domain/repositories/horarios_repository.dart';
import 'package:libreria/domain/repositories/libro_repository.dart';
import 'package:libreria/domain/repositories/preferencias_repository.dart';
import 'package:libreria/domain/services/auth_service.dart';
import 'package:libreria/domain/services/fotos.dart';
import 'package:libreria/domain/services/info_libro_service.dart';
import 'package:libreria/presentation/ajustes/viewmodels/ajustes_view_model.dart';
import 'package:libreria/presentation/favoritos/viewmodels/favoritos_view_model.dart';

/// Lo necesario para el panel; solo existe si hay conexión con Firebase.
class Administracion {
  const Administracion({
    required this.auth,
    required this.catalogo,
    required this.horarios,
    required this.catalogoDeEjemplo,
  });

  final AuthService auth;
  final CatalogoAdminRepository catalogo;
  final HorariosAdminRepository horarios;
  final LibroRepository catalogoDeEjemplo;
}

/// Único lugardonde se elige de dónde vienen los datos y qué servicios se
/// usan. Los tests pasan versiones falsas.
class Servicios {
  Servicios({
    LibroRepository? libros,
    EscuelaRepository? escuelas,
    HorariosRepository? horarios,
    PreferenciasRepository? preferencias,
    InfoLibroService? infoLibros,
    ServicioAvisos? avisos,
    Stream<bool> Function()? conexion,
    ServicioPush? push,
    FuenteFotos? fotos,
    BorradorFoto? borradorFoto,
    this.administracion,
  }) : libros = libros ?? AssetLibroRepository(),
       escuelas = escuelas ?? InMemoryEscuelaRepository(),
       horarios = horarios ?? InMemoryHorariosRepository(),
       preferencias = preferencias ?? SharedPreferenciasRepository(),
       infoLibros = infoLibros ?? OpenLibraryService(),
       avisos = avisos ?? ServicioAvisosDispositivo(),
       conexion = conexion ?? estadoConexion,
       push = push ?? const SinPush(),
       fotos = fotos ?? ImagePickerFuente(),
       borradorFoto = borradorFoto ?? ArchivoBorradorFoto();

  final LibroRepository libros;
  final EscuelaRepository escuelas;
  final HorariosRepository horarios;
  final PreferenciasRepository preferencias;
  final InfoLibroService infoLibros;
  final ServicioAvisos avisos;
  final Stream<bool> Function() conexion;
  final ServicioPush push;
  final FuenteFotos fotos;
  final BorradorFoto borradorFoto;
  final Administracion? administracion;

  /// Estado compartido por varias pantallas.
  late final favoritos = FavoritosViewModel(preferencias)..cargar();
  late final ajustes = AjustesViewModel(preferencias, avisos, push)..cargar();

  void dispose() {
    favoritos.dispose();
    ajustes.dispose();
  }
}

/// Entrega los [Servicios] a cualquier pantalla del árbol.
class Dependencias extends InheritedWidget {
  const Dependencias({
    super.key,
    required this.servicios,
    required super.child,
  });

  final Servicios servicios;

  static Servicios of(BuildContext context) {
    final dependencias = context.getInheritedWidgetOfExactType<Dependencias>();
    assert(dependencias != null, 'Falta Dependencias sobre este widget');
    return dependencias!.servicios;
  }

  @override
  bool updateShouldNotify(Dependencias oldWidget) =>
      servicios != oldWidget.servicios;
}
