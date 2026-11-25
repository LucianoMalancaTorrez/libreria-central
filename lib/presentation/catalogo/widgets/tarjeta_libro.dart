import 'package:libreria/core/widgets/tapa_libro.dart';
import 'package:flutter/material.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/theme/app_theme.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/presentation/catalogo/libro_detalle_screen.dart';
import 'package:libreria/presentation/catalogo/widgets/boton_favorito.dart';
import 'package:libreria/presentation/catalogo/widgets/hoja_consulta.dart';

void abrirDetalle(BuildContext context, Libro libro) => Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => LibroDetalleScreen(libro: libro)),
);

/// Gestos: un toque abre el detalle, dos toques lo suman a la lista y mantener
/// presionado abre la consulta por WhatsApp.
class TarjetaLibro extends StatelessWidget {
  const TarjetaLibro({super.key, required this.libro});

  final Libro libro;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => abrirDetalle(context, libro),
        onDoubleTap: () =>
            Dependencias.of(context).favoritos.alternar(libro.id),
        onLongPress: () => mostrarHojaConsulta(context, libro),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tapa de reemplazo hasta tener las fotos reales.
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.leather.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.brass.withValues(alpha: 0.5),
                        ),
                      ),
                      child: TapaLibro(libro: libro, tamanoIcono: 40),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: BotonFavorito(libro: libro),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                libro.titulo,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                libro.autor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
