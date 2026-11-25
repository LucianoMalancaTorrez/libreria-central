import 'package:libreria/domain/repositories/preferencias_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenciasRepository implements PreferenciasRepository {
  @override
  Future<List<String>> leerLista(String clave) async =>
      (await SharedPreferences.getInstance()).getStringList(clave) ?? const [];

  @override
  Future<void> guardarLista(String clave, List<String> valor) async =>
      (await SharedPreferences.getInstance()).setStringList(clave, valor);

  @override
  Future<bool> leerBool(String clave) async =>
      (await SharedPreferences.getInstance()).getBool(clave) ?? false;

  @override
  Future<void> guardarBool(String clave, bool valor) async =>
      (await SharedPreferences.getInstance()).setBool(clave, valor);
}
