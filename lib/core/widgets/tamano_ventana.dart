/// Clases de tamaño de ventana de Material 3. Se decide por el ancho
/// disponible, nunca preguntando si es "celular" o "tablet".
enum TamanoVentana { compacta, mediana, expandida }

TamanoVentana tamanoDeVentana(double ancho) {
  if (ancho < 600) return TamanoVentana.compacta;
  if (ancho < 840) return TamanoVentana.mediana;
  return TamanoVentana.expandida;
}
