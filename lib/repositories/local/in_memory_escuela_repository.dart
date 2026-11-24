// lib/repositories/local/in_memory_escuela_repository.dart
// Implementación local en memoria con las escuelas y condiciones
// confirmadas por Amelia Winterbach:
// - Descuento del 10% exclusivo para literatura, cuentos y novelas.
// - Válido durante el ciclo lectivo (marzo a diciembre).
// - Escuelas vinculadas: Colegio San José y Escuela Sarmiento.

import '../../models/escuela.dart';
import '../escuela_repository.dart';

/// Porcentaje de descuento comercial confirmado por Amelia:
/// 10% en literatura, novelas y cuentos (los manuales escolares tienen margen editorial fijo sin descuento).
const int kDescuentoPorcentajeConfirmado = 10;

/// Número de WhatsApp de Librería Central para consultas sobre convenios.
const String kTelefonoWhatsAppEscuelas = '5492610000000';

class InMemoryEscuelaRepository implements EscuelaRepository {
  final List<Escuela> _escuelas;

  InMemoryEscuelaRepository({List<Escuela>? escuelas})
      : _escuelas = escuelas ?? _escuelasReales;

  static final List<Escuela> _escuelasReales = [
    Escuela(
      id: 'esc-sarmiento',
      nombre: 'Escuela Sarmiento',
      localidad: 'Escuela del barrio, Mendoza',
      descuentoPorcentaje: kDescuentoPorcentajeConfirmado,
      vigenteHasta: DateTime(2027, 12, 31),
      codigo: 'SARMIENTO-10',
      alcance: '10% en literatura, cuentos y novelas (no incluye manuales de texto)',
    ),
    Escuela(
      id: 'esc-san-jose',
      nombre: 'Colegio San José',
      localidad: 'Mendoza',
      descuentoPorcentaje: kDescuentoPorcentajeConfirmado,
      vigenteHasta: DateTime(2027, 12, 31),
      codigo: 'SANJOSE-10',
      alcance: '10% en literatura, cuentos y novelas (no incluye manuales de texto)',
    ),
    Escuela(
      id: 'esc-ejemplo-3',
      nombre: 'Instituto Secundario del Barrio',
      localidad: 'Mendoza',
      descuentoPorcentaje: kDescuentoPorcentajeConfirmado,
      vigenteHasta: DateTime(2027, 12, 31),
      codigo: 'INST-SEC-10',
      alcance: '10% en literatura, cuentos y novelas (no incluye manuales de texto)',
    ),
  ];

  @override
  Future<List<Escuela>> getEscuelas() async {
    return List.unmodifiable(_escuelas);
  }

  @override
  Future<Escuela?> getEscuelaPorId(String id) async {
    try {
      return _escuelas.firstWhere((escuela) => escuela.id == id);
    } catch (_) {
      return null;
    }
  }
}
