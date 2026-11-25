import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:libreria/data/repositories/in_memory_horarios_repository.dart';
import 'package:libreria/domain/models/horario_atencion.dart';
import 'package:libreria/domain/repositories/horarios_repository.dart';

/// Horarios editables en `config/horarios`; si no existen, los habituales.
class FirestoreHorariosRepository extends InMemoryHorariosRepository
    implements HorariosAdminRepository {
  FirestoreHorariosRepository(this._base);

  final FirebaseFirestore _base;

  DocumentReference<Map<String, dynamic>> get _doc =>
      _base.collection('config').doc('horarios');

  @override
  Stream<Horarios> observarHorarios() async* {
    try {
      await for (final doc in _doc.snapshots()) {
        final datos = doc.data();
        yield datos == null
            ? Horarios.habituales
            : Horarios(
                invierno: HorarioTemporada.fromList(
                  datos['invierno'] as List<dynamic>,
                ),
                verano: HorarioTemporada.fromList(
                  datos['verano'] as List<dynamic>,
                ),
              );
      }
    } catch (e) {
      debugPrint('Horarios en la nube no disponibles: $e');
      yield Horarios.habituales;
    }
  }

  @override
  Future<void> guardarHorarios(Horarios horarios) => _doc.set({
    'invierno': horarios.invierno.toList(),
    'verano': horarios.verano.toList(),
  });
}
