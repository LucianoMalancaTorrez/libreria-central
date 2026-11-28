import 'package:flutter/material.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/domain/services/avisos.dart';

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
                  onPressed: servicios.club.abrirAjustes,
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
    final club = Dependencias.of(context).club;
    final mensajero = ScaffoldMessenger.of(context);
    if (await club.probarAviso()) return;
    mensajero.showSnackBar(
      const SnackBar(content: Text('No se pudo mostrar el aviso.')),
    );
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
              servicios.club.puedeAvisar
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
