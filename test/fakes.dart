import 'dart:async';

import 'package:libreria/app/dependencias.dart';
import 'package:libreria/domain/services/auth_service.dart';
import 'package:libreria/core/services/avisos.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/domain/repositories/libro_repository.dart';
import 'package:libreria/domain/repositories/preferencias_repository.dart';
import 'package:libreria/domain/services/info_libro_service.dart';

const librosDePrueba = [
  Libro(id: '1', titulo: 'Rayuela', autor: 'Julio Cortázar', genero: 'Novela'),
  Libro(
    id: '2',
    titulo: 'Cien Años de Soledad',
    autor: 'Gabriel García Márquez',
    genero: 'Novela',
  ),
  Libro(
    id: '3',
    titulo: 'Ficciones',
    autor: 'Jorge Luis Borges',
    genero: 'Cuento',
  ),
];

class LibrosFalsos implements LibroRepository {
  LibrosFalsos({this.falla = false});
  final bool falla;

  @override
  Stream<List<Libro>> observarLibros() => falla
      ? Stream.error(Exception('Sin conexión'))
      : Stream.value(librosDePrueba);
}

class PreferenciasEnMemoria implements PreferenciasRepository {
  final Map<String, Object> datos = {};

  @override
  Future<List<String>> leerLista(String clave) async =>
      List.of(datos[clave] as List<String>? ?? const []);

  @override
  Future<void> guardarLista(String clave, List<String> valor) async =>
      datos[clave] = valor;

  @override
  Future<bool> leerBool(String clave) async => datos[clave] as bool? ?? false;

  @override
  Future<void> guardarBool(String clave, bool valor) async =>
      datos[clave] = valor;
}

class AvisosFalsos implements ServicioAvisos {
  AvisosFalsos([this.permiso = ResultadoPermiso.concedido]);
  final ResultadoPermiso permiso;
  bool? revision;

  @override
  bool get soportaSegundoPlano => true;
  @override
  Future<ResultadoPermiso> pedirPermiso() async => permiso;
  @override
  Future<void> mostrar(String titulo, String cuerpo) async {}
  @override
  Future<void> programarRevision(bool activa) async => revision = activa;
  @override
  Future<void> abrirAjustes() async {}
}

class InfoFalsa implements InfoLibroService {
  @override
  Future<InfoExterna?> buscar(String titulo, String autor) async =>
      const InfoExterna(primeraEdicion: 1963);
}

Servicios serviciosDePrueba({bool conexion = true}) => Servicios(
  libros: LibrosFalsos(),
  preferencias: PreferenciasEnMemoria(),
  infoLibros: InfoFalsa(),
  avisos: AvisosFalsos(),
  conexion: () => Stream.value(conexion),
);

class AuthFalso implements AuthService {
  AuthFalso({this.admin = true, this.falla = false});
  final bool admin;
  final bool falla;
  final _cambios = StreamController<Usuario?>.broadcast();

  @override
  Stream<Usuario?> observarUsuario() => _cambios.stream;
  @override
  Future<void> ingresar(String email, String clave) async {
    if (falla) throw Exception('clave incorrecta');
    _cambios.add(Usuario(uid: 'uid-1', email: email));
  }

  @override
  Future<void> salir() async => _cambios.add(null);
  @override
  Future<bool> esAdministrador(String uid) async => admin;
}
