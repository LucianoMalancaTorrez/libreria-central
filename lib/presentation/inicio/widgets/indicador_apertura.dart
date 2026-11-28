import 'dart:async';

import 'package:flutter/material.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/theme/app_theme.dart';
import 'package:libreria/domain/logic/horario_comercial.dart';
import 'package:libreria/domain/models/horario_atencion.dart';

/// "Abierto ahora / Cerrado", actualizado solo mientras está en pantalla.
class IndicadorApertura extends StatefulWidget {
  const IndicadorApertura({super.key, this.reloj = DateTime.now});

  final DateTime Function() reloj;

  @override
  State<IndicadorApertura> createState() => _IndicadorAperturaState();
}

class _IndicadorAperturaState extends State<IndicadorApertura> {
  Horarios _horarios = Horarios.habituales;
  StreamSubscription<Horarios>? _suscripcion;
  late final Timer _reloj;
  late final AppLifecycleListener _cicloDeVida;

  @override
  void initState() {
    super.initState();
    _reloj = Timer.periodic(const Duration(seconds: 30), (_) => _refrescar());
    // Al volver a la app puede haber pasado mucho tiempo: se piden los
    // horarios otra vez y se recalcula.
    _cicloDeVida = AppLifecycleListener(
      onResume: () {
        _escucharHorarios();
        _refrescar();
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_suscripcion == null) _escucharHorarios();
  }

  void _escucharHorarios() {
    _suscripcion?.cancel();
    _suscripcion = Dependencias.of(context).horarios
        .observarHorarios()
        .listen((nuevos) => setState(() => _horarios = nuevos));
  }

  void _refrescar() => setState(() {});

  @override
  void dispose() {
    _reloj.cancel();
    _suscripcion?.cancel();
    _cicloDeVida.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estado = estadoDelLocal(widget.reloj(), _horarios);
    final color = estado.abierto
        ? context.colores.bottleGreen
        : context.colores.leatherDeep;
    final texto =
        '${estado.abierto ? 'Abierto ahora' : 'Cerrado'} · ${estado.detalle}';
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color, width: 1.5),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Row(
          key: ValueKey(texto),
          children: [
            Icon(
              estado.abierto ? Icons.door_front_door : Icons.lock_clock,
              color: color,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                texto,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
