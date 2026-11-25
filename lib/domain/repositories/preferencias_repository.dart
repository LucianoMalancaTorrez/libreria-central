/// Datos que se guardan en el propio dispositivo.
abstract class PreferenciasRepository {
  Future<List<String>> leerLista(String clave);
  Future<void> guardarLista(String clave, List<String> valor);
  Future<bool> leerBool(String clave);
  Future<void> guardarBool(String clave, bool valor);
}
