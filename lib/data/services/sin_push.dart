import 'package:libreria/domain/services/push.dart';

/// Web, iPhone y tests: no hay push.
class SinPush implements ServicioPush {
  const SinPush();

  @override
  Future<void> suscribir(bool activo) async {}
  @override
  Stream<AvisoPush> get recibidos => const Stream.empty();
  @override
  Stream<String> get toques => const Stream.empty();
  @override
  Future<String?> tocadoAlAbrir() async => null;
}
