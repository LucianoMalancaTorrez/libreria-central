import 'package:flutter/material.dart';
import 'package:libreria/core/theme/app_theme.dart';

/// Franja que aparece sola cuando el sistema avisa que no hay conexión.
class AvisoSinConexion extends StatefulWidget {
  const AvisoSinConexion({super.key, required this.conexion});

  /// Quien lo usa decide de dónde sale el estado de la conexión.
  final Stream<bool> Function() conexion;

  @override
  State<AvisoSinConexion> createState() => _AvisoSinConexionState();
}

class _AvisoSinConexionState extends State<AvisoSinConexion> {
  // El Stream se crea una sola vez, no en cada build.
  late final Stream<bool> _conexion = widget.conexion();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _conexion,
      initialData: true,
      builder: (context, snapshot) => AnimatedSize(
        duration: const Duration(milliseconds: 300),
        child: snapshot.data == false
            ? ColoredBox(
                color: context.colores.leatherDeep,
                child: SafeArea(
                  bottom: false,
                  child: ListTile(
                    leading: Icon(
                      Icons.wifi_off,
                      color: context.colores.parchment,
                    ),
                    title: Text(
                      'Sin conexión. Podés seguir mirando el catálogo.',
                      style: TextStyle(color: context.colores.parchment),
                    ),
                  ),
                ),
              )
            : const SizedBox(width: double.infinity),
      ),
    );
  }
}
