/// Panel para que Amelia (o quien la ayude) actualice libros y horarios.
library;

import 'package:flutter/material.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/widgets/responsive_center.dart';
import 'package:libreria/presentation/admin/viewmodels/acceso_view_model.dart';
import 'package:libreria/presentation/admin/widgets/formulario_ingreso.dart';
import 'package:libreria/presentation/admin/widgets/pestana_horarios.dart';
import 'package:libreria/presentation/admin/widgets/pestana_libros.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  late final AccesoViewModel _acceso = AccesoViewModel(
    Dependencias.of(context).administracion!.auth,
  );

  @override
  void dispose() {
    _acceso.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _acceso,
      builder: (context, _) {
        final usuario = _acceso.usuario;
        final dentro = usuario != null && _acceso.habilitado == true;
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Administración'),
              actions: [
                if (usuario != null)
                  IconButton(
                    tooltip: 'Salir',
                    onPressed: _acceso.salir,
                    icon: const Icon(Icons.logout),
                  ),
              ],
              bottom: dentro
                  ? const TabBar(
                      tabs: [
                        Tab(text: 'Libros'),
                        Tab(text: 'Horarios'),
                      ],
                    )
                  : null,
            ),
            body: ResponsiveCenter(child: _cuerpo()),
          ),
        );
      },
    );
  }

  Widget _cuerpo() {
    final usuario = _acceso.usuario;
    if (usuario == null) return FormularioIngreso(viewModel: _acceso);
    return switch (_acceso.habilitado) {
      null => const Center(child: CircularProgressIndicator()),
      true => const TabBarView(children: [PestanaLibros(), PestanaHorarios()]),
      false => ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Esta cuenta todavía no está habilitada. En la consola de '
            'Firebase, creá un documento en la colección "admins" cuyo '
            'identificador sea:',
          ),
          const SizedBox(height: 12),
          SelectableText(
            usuario.uid,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          const Text('Después salí y volvé a ingresar.'),
        ],
      ),
    };
  }
}
