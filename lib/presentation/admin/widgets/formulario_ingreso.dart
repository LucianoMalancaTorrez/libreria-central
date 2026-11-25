import 'package:flutter/material.dart';
import 'package:libreria/presentation/admin/viewmodels/acceso_view_model.dart';

class FormularioIngreso extends StatefulWidget {
  const FormularioIngreso({super.key, required this.viewModel});

  final AccesoViewModel viewModel;

  @override
  State<FormularioIngreso> createState() => _FormularioIngresoState();
}

class _FormularioIngresoState extends State<FormularioIngreso> {
  final _formulario = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _clave = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _clave.dispose();
    super.dispose();
  }

  void _ingresar() {
    if (_formulario.currentState!.validate()) {
      widget.viewModel.ingresar(_email.text, _clave.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    return Form(
      key: _formulario,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Solo para la librería. Los clientes no necesitan una cuenta.',
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: const InputDecoration(labelText: 'Correo'),
            validator: (v) =>
                (v ?? '').contains('@') ? null : 'Escribí tu correo',
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _clave,
            obscureText: true,
            autofillHints: const [AutofillHints.password],
            decoration: const InputDecoration(labelText: 'Contraseña'),
            validator: (v) =>
                (v ?? '').isEmpty ? 'Escribí tu contraseña' : null,
            onFieldSubmitted: (_) => _ingresar(),
          ),
          const SizedBox(height: 16),
          if (viewModel.error != null) ...[
            Text(viewModel.error!),
            const SizedBox(height: 12),
          ],
          ElevatedButton(
            onPressed: viewModel.cargando ? null : _ingresar,
            child: Text(viewModel.cargando ? 'Ingresando...' : 'Ingresar'),
          ),
        ],
      ),
    );
  }
}
