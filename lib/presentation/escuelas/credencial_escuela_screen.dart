/// Credencial visual para canjear el descuento de la escuela en el local.
/// Adaptada según las observaciones de Amelia:
/// - Tipografía grande y de alto contraste para facilitar la lectura de Amelia en caja.
/// - Código alfanumérico simple (sin necesidad de escanear códigos QR complejos).
/// - Requiere presentar el carnet escolar del alumno o docente.
/// - Aclara el alcance acordado: 10% en literatura, cuentos y novelas (excluye manuales de texto).
/// - Validez durante el ciclo lectivo (marzo a diciembre).
library;

import 'package:flutter/material.dart';
import 'package:libreria/core/widgets/responsive_center.dart';
import 'package:libreria/domain/models/escuela.dart';
import 'package:libreria/presentation/escuelas/widgets/instrucciones_canje.dart';
import 'package:libreria/presentation/escuelas/widgets/tarjeta_credencial.dart';

class CredencialEscuelaScreen extends StatelessWidget {
  final Escuela escuela;

  const CredencialEscuelaScreen({super.key, required this.escuela});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mostrá esto en caja')),
      body: ResponsiveCenter(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TarjetaCredencial(escuela: escuela),
              const SizedBox(height: 24),
              InstruccionesCanje(escuela: escuela),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Volver a la lista de escuelas'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
