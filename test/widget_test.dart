import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libreria/app/app.dart';

import 'fakes.dart';

/// Pantalla alta como la de un celular: las listas construyen solo lo visible.
Future<void> abrirApp(
  WidgetTester tester, {
  Size tamano = const Size(420, 1800),
  bool conexion = true,
}) async {
  tester.view.physicalSize = tamano;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    LibreriaApp(servicios: serviciosDePrueba(conexion: conexion)),
  );
  await tester.pumpAndSettle();
}

Future<void> tocar(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Finder pestana(String texto) =>
    find.descendant(of: find.byType(NavigationBar), matching: find.text(texto));

Future<void> letraMuyGrande(WidgetTester tester) async {
  await tester.drag(find.byType(Slider), const Offset(600, 0));
  await tester.pumpAndSettle();
  expect(find.text('Tamaño de letra: Muy grande'), findsOneWidget);
}

void main() {
  testWidgets('El celular usa barra inferior', (tester) async {
    await abrirApp(tester);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Librería Central Winterbach'), findsOneWidget);
    expect(find.textContaining('Sin conexión'), findsNothing);
  });

  testWidgets('La pantalla ancha usa barra lateral', (tester) async {
    await abrirApp(tester, tamano: const Size(1200, 900));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('Avisa cuando no hay conexión', (tester) async {
    await abrirApp(tester, conexion: false);

    expect(find.textContaining('Sin conexión'), findsOneWidget);
  });

  testWidgets('Guardar, quitar deslizando y deshacer', (tester) async {
    await abrirApp(tester);
    await tocar(tester, pestana('Catálogo'));
    await tocar(tester, find.byTooltip('Agregar a mi lista').first);
    await tocar(tester, pestana('Mi lista'));
    expect(find.text('Enviar por WhatsApp'), findsOneWidget);

    await tester.drag(find.byType(Dismissible), const Offset(-400, 0));
    await tester.pumpAndSettle();
    expect(find.textContaining('Todavía no guardaste'), findsOneWidget);

    await tocar(tester, find.text('Deshacer'));
    expect(find.text('Enviar por WhatsApp'), findsOneWidget);
  });

  testWidgets('Todas las secciones abren sin errores', (tester) async {
    await abrirApp(tester);
    await tocar(tester, pestana('Más'));

    for (final seccion in [
      'Club de lectura',
      'Convenios con escuelas',
      'Horarios y contacto',
      'Nuestra historia',
      'Privacidad y permisos',
    ]) {
      await tocar(tester, find.text(seccion).last);
      expect(tester.takeException(), isNull, reason: seccion);
      await tocar(tester, find.byType(BackButton));
    }
  });

  testWidgets('Con letra grande no se desborda nada', (tester) async {
    await abrirApp(tester, tamano: const Size(360, 740));
    await tocar(tester, pestana('Más'));
    await letraMuyGrande(tester);

    for (final nombre in ['Inicio', 'Catálogo', 'Mi lista', 'Más']) {
      await tocar(tester, pestana(nombre));
      expect(tester.takeException(), isNull, reason: nombre);
    }
  });

  testWidgets('La credencial entra en un celular chico con letra grande', (
    tester,
  ) async {
    await abrirApp(tester, tamano: const Size(360, 2400));
    await tocar(tester, pestana('Más'));
    await letraMuyGrande(tester);
    await tocar(tester, find.text('Convenios con escuelas'));
    await tocar(tester, find.text('Mostrá esto en caja').first);

    expect(find.text('SARMIENTO-10'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('El detalle muestra los datos externos', (tester) async {
    await abrirApp(tester);
    await tocar(tester, pestana('Catálogo'));
    await tester.tap(find.text('Cien Años de Soledad').first);
    // El doble toque obliga a esperar antes de confirmar el toque simple.
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('Primera edición: 1963'), findsOneWidget);
  });

  testWidgets('El menú ordena el catálogo por autor', (tester) async {
    await abrirApp(tester);
    await tocar(tester, pestana('Catálogo'));
    await tocar(tester, find.byTooltip('Ordenar'));
    await tocar(tester, find.text('Por autor'));

    expect(tester.takeException(), isNull);
  });

  testWidgets('Ctrl+2 abre el catálogo desde el teclado', (tester) async {
    await abrirApp(tester, tamano: const Size(1200, 900));

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();

    expect(find.text('Destacados'), findsOneWidget);
  });

  testWidgets('Al ocultarse la app se guarda la búsqueda', (tester) async {
    tester.view.physicalSize = const Size(420, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final servicios = serviciosDePrueba();
    await tester.pumpWidget(LibreriaApp(servicios: servicios));
    await tester.pumpAndSettle();
    await tocar(tester, pestana('Catálogo'));
    await tester.enterText(find.byType(TextField), 'borges');

    // En el orden real en que Android avisa.
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    await tester.pumpAndSettle();

    expect(await servicios.preferencias.leerLista('ultima_busqueda'), [
      'borges',
    ]);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
  });
}
