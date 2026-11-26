import 'package:flutter/foundation.dart';
import 'package:libreria/core/viewmodels/view_model.dart';
import 'package:libreria/domain/models/horario_atencion.dart';
import 'package:libreria/domain/repositories/horarios_repository.dart';

enum Temporada { invierno, verano }

/// Lógica de la pestaña Horarios: editar, validar y guardar.
class HorariosAdminViewModel extends ViewModel {
  HorariosAdminViewModel(this._lectura, this._escritura);

  final HorariosRepository _lectura;
  final HorariosAdminRepository _escritura;

  /// Cuatro horas por temporada, en minutos desde la medianoche.
  final Map<Temporada, List<int>> _horas = {};

  List<int> horas(Temporada temporada) =>
      List.unmodifiable(_horas[temporada] ?? const []);

  Future<void> cargar() => ejecutar(() async {
    final actuales = await _lectura.observarHorarios().first;
    _horas[Temporada.invierno] = actuales.invierno.toList();
    _horas[Temporada.verano] = actuales.verano.toList();
  }, mensajeError: 'No se pudieron cargar los horarios.');

  void cambiar(Temporada temporada, int posicion, int minutos) {
    _horas[temporada]![posicion] = minutos;
    notifyListeners();
  }

  /// Devuelve el resultado en palabras para mostrarlo en pantalla.
  Future<String> guardar() async {
    for (final t in _horas.values) {
      if (!(t[0] < t[1] && t[1] <= t[2] && t[2] < t[3])) {
        return 'Revisá el orden de las horas.';
      }
    }
    try {
      await _escritura.guardarHorarios(
        Horarios(
          invierno: HorarioTemporada.fromList(_horas[Temporada.invierno]!),
          verano: HorarioTemporada.fromList(_horas[Temporada.verano]!),
        ),
      );
      return 'Horarios guardados';
    } catch (e) {
      debugPrint('Horarios: $e');
      return 'No se pudieron guardar.';
    }
  }
}
