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
    if (!servicios.club.puedeAvisar) return const _SinAvisos();
    return ListenableBuilder(
      listenable: servicios.ajustes,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Avisarme los jueves'),
            subtitle: const Text('Te llega aunque la app esté cerrada.'),
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

/// Web y iPhone: se cuenta qué falta y por qué, en vez de un botón que no anda.
class _SinAvisos extends StatelessWidget {
  const _SinAvisos();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Card(
          child: ListTile(
            leading: Icon(Icons.notifications_off_outlined),
            title: Text('Acá no hay avisos'),
            subtitle: Text(
              'Los avisos funcionan en la aplicación para Android.',
            ),
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Aviso de los jueves: una página web no puede dejar un aviso '
          'programado para cuando está cerrada.',
        ),
        SizedBox(height: 8),
        Text(
          'Avisos de libros nuevos: todavía no están preparados para la web '
          'ni para iPhone.',
        ),
        SizedBox(height: 8),
        Text('Todo lo demás se puede usar igual.'),
      ],
    );
  }
}
