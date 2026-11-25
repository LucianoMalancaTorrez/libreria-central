import 'package:connectivity_plus/connectivity_plus.dart';

/// Stream que avisa cada vez que se gana o se pierde la conexión.
Stream<bool> estadoConexion() async* {
  final conectividad = Connectivity();
  bool hayRed(List<ConnectivityResult> r) =>
      !r.contains(ConnectivityResult.none);

  yield hayRed(await conectividad.checkConnectivity());
  yield* conectividad.onConnectivityChanged.map(hayRed);
}
