/// Club de lectura de los jueves: próximos encuentros y avisos.
library;

import 'package:flutter/material.dart';
import 'package:libreria/core/widgets/responsive_center.dart';
import 'package:libreria/presentation/eventos/widgets/pestana_avisos.dart';
import 'package:libreria/presentation/eventos/widgets/pestana_encuentros.dart';

class EventosScreen extends StatelessWidget {
  const EventosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Club de lectura'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Encuentros'),
              Tab(text: 'Avisos'),
            ],
          ),
        ),
        body: const ResponsiveCenter(
          child: TabBarView(children: [PestanaEncuentros(), PestanaAvisos()]),
        ),
      ),
    );
  }
}
