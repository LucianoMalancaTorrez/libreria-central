import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libreria/core/plataforma/politicas.dart';
import 'package:libreria/core/widgets/tamano_ventana.dart';

/// Hace de cuenta que la prueba corre en otra plataforma.
void simularPlataforma(TargetPlatform plataforma) {
  debugDefaultTargetPlatformOverride = plataforma;
  addTearDown(() => debugDefaultTargetPlatformOverride = null);
}

void main() {
  test('en Android se ofrece la foto y el aviso automático', () {
    simularPlataforma(TargetPlatform.android);

    expect(const Politicas().ofrecerSacarFoto, isTrue);
    expect(const Politicas().ofrecerAvisoAutomatico, isTrue);
  });

  test('en iPhone hay foto pero no aviso automático', () {
    simularPlataforma(TargetPlatform.iOS);

    expect(const Politicas().ofrecerSacarFoto, isTrue);
    expect(const Politicas().ofrecerAvisoAutomatico, isFalse);
  });

  test('en una computadora no se ofrece sacar foto', () {
    simularPlataforma(TargetPlatform.windows);

    expect(const Politicas().ofrecerSacarFoto, isFalse);
  });

  test('los cortes de ventana son 600 y 840', () {
    expect(tamanoDeVentana(599), TamanoVentana.compacta);
    expect(tamanoDeVentana(600), TamanoVentana.mediana);
    expect(tamanoDeVentana(840), TamanoVentana.expandida);
  });
}
