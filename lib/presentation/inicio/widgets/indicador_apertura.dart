import 'package:flutter/material.dart';
import 'package:libreria/core/theme/app_theme.dart';
import 'package:libreria/domain/logic/horario_comercial.dart';

/// "Abierto ahora / Cerrado", actualizado solo mientras está en pantalla.
class IndicadorApertura extends StatefulWidget {
  const IndicadorApertura({super.key, this.reloj = DateTime.now});

  final DateTime Function() reloj;

  @override
  State<IndicadorApertura> createState() => _IndicadorAperturaState();
}

class _IndicadorAperturaState extends State<IndicadorApertura> {
  late Stream<EstadoLocal> _estados;
  late final AppLifecycleListener _cicloDeVida;

  @override
  void initState() {
    super.initState();
    _estados = _crearStream();
    // Al volver a la app puede haber pasado mucho tiempo: se recalcula.
    _cicloDeVida = AppLifecycleListener(
      onResume: () => setState(() => _estados = _crearStream()),
    );
  }

  Stream<EstadoLocal> _crearStream() => Stream.periodic(
    const Duration(seconds: 30),
    (_) => estadoDelLocal(widget.reloj()),
  ).distinct();

  @override
  void dispose() {
    _cicloDeVida.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EstadoLocal>(
      stream: _estados,
      initialData: estadoDelLocal(widget.reloj()),
      builder: (context, snapshot) {
        final estado = snapshot.data!;
        final color = estado.abierto
            ? AppColors.bottleGreen
            : AppColors.leatherDeep;
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
              key: ValueKey(estado),
              children: [
                Icon(
                  estado.abierto ? Icons.door_front_door : Icons.lock_clock,
                  color: color,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${estado.abierto ? 'Abierto ahora' : 'Cerrado'} · '
                    '${estado.detalle}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
