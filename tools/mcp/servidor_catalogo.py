"""Servidor MCP del catálogo de la Librería Central (solo lectura).

Expone las tres primitivas de MCP: herramientas, un recurso y un prompt.
Trabaja sobre assets/data/libros.json; no se conecta a ningún servicio.
"""
import json
import unicodedata
from collections import Counter
from pathlib import Path

from mcp.server.fastmcp import Context, FastMCP

CATALOGO = Path(__file__).resolve().parents[2] / "assets" / "data" / "libros.json"
OBLIGATORIOS = ("id", "titulo", "autor", "genero")

mcp = FastMCP("catalogo-libreria")


def _libros() -> list[dict]:
    return json.loads(CATALOGO.read_text(encoding="utf-8"))


def _normalizar(texto: str) -> str:
    sin_tildes = unicodedata.normalize("NFKD", texto.lower())
    return "".join(c for c in sin_tildes if not unicodedata.combining(c)).strip()


@mcp.tool()
def buscar_libros(texto: str, limite: int = 10) -> list[dict]:
    """Busca por título, autor o género, sin distinguir tildes ni mayúsculas."""
    buscado = _normalizar(texto)
    hallados = [
        {k: libro[k] for k in OBLIGATORIOS}
        for libro in _libros()
        if any(buscado in _normalizar(libro[k]) for k in ("titulo", "autor", "genero"))
    ]
    return hallados[: max(0, limite)]


@mcp.tool()
async def validar_catalogo(ctx: Context) -> dict:
    """Revisa datos faltantes, ids repetidos, duplicados y precios prohibidos."""
    libros = _libros()
    # Notificación al cliente mientras trabaja.
    await ctx.info(f"Validando {len(libros)} libros")
    problemas = []
    for libro in libros:
        faltan = [c for c in OBLIGATORIOS if not str(libro.get(c, "")).strip()]
        if faltan:
            problemas.append(f"{libro.get('id', '?')}: falta {', '.join(faltan)}")
        if "precio" in libro:
            problemas.append(f"{libro['id']}: tiene precio y la clienta no quiere precios")
    for campo, valores in (
        ("id", [x.get("id") for x in libros]),
        ("título y autor", [(_normalizar(x["titulo"]), _normalizar(x["autor"])) for x in libros]),
    ):
        for valor, veces in Counter(valores).items():
            if veces > 1:
                problemas.append(f"{campo} repetido: {valor}")
    return {
        "total": len(libros),
        "por_genero": dict(Counter(x["genero"] for x in libros)),
        "problemas": problemas,
    }


@mcp.resource("catalogo://libros")
def catalogo_completo() -> str:
    """El catálogo de ejemplo tal como lo lee la app."""
    return CATALOGO.read_text(encoding="utf-8")


@mcp.prompt()
def revisar_catalogo() -> str:
    """Pedido listo para revisar el catálogo antes de publicar."""
    return (
        "Usá validar_catalogo y resumí los problemas. No inventes libros ni "
        "datos: lo que falte confirmar con Amelia marcalo como pendiente."
    )


if __name__ == "__main__":
    mcp.run()
