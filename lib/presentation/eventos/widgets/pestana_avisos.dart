import 'package:flutter/material.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/services/avisos.dart';

class PestanaAvisos extends StatelessWidget {
  const PestanaAvisos({super.key});

  Future<void> _cambiar(BuildContext context, bool activar) async {
    final servicios = Dependencias.of(context);
    final mensajero = ScaffoldMessenger.of(context);
    try {
      final permiso = await servicios.ajustes.cambiarAvisosClub(activar);
      if (permiso == ResultadoPermiso.concedido) return;
      mensajero.showSnackBar(
        SnackBar(
          content: const Text('Sin permiso no podemos avisarte.'),
          persist: false,
          action: permiso == ResultadoPermiso.bloqueado
              ? SnackBarAction(
                  label: 'Abrir ajustes',
                  onPressed: servicios.avisos.abrirAjustes,
                )
              : null,
        ),
      );
    } catch (e) {
      debugPrint('Avisos: $e');
      mensajero.showSnackBar(
        const SnackBar(content: Text('Este dispositivo no permite avisos.')),
      );
    }
  }

  Future<void> _probar(BuildContext context) async {
    final servicios = Dependencias.of(context);
    final mensajero = ScaffoldMessenger.of(context);
    try {
      await servicios.avisos.mostrar(
        'Club de lectura',
        'Así te vamos a avisar los jueves.',
      );
    } catch (e) {
      debugPrint('Aviso de prueba: $e');
      mensajero.showSnackBar(
        const SnackBar(content: Text('No se pudo mostrar el aviso.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final servicios = Dependencias.of(context);
    return ListenableBuilder(
      listenable: servicios.ajustes,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Avisarme los jueves'),
            subtitle: Text(
              servicios.avisos.soportaSegundoPlano
                  ? 'Te llega aunque la app esté cerrada.'
                  : 'El aviso automático funciona en la app para Android.',
            ),
            value: servicios.ajustes.avisosClub,
            onChanged: (valor) => _cambiar(context, valor),
          ),
          if (servicios.ajustes.avisosClub)
            OutlinedButton.icon(
              onPressed: () => _probar(context),
              icon: const Icon(Icons.notifications_active_outlined),
              label: const Text('Probar un aviso ahora'),
            ),
        ],
      ),
    );
  }
}
