"""Cliente de prueba: se conecta al servidor por stdio y usa cada primitiva."""
import asyncio
import sys
from pathlib import Path

from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

SERVIDOR = Path(__file__).with_name("servidor_catalogo.py")


async def main() -> None:
    parametros = StdioServerParameters(command=sys.executable, args=[str(SERVIDOR)])
    async with stdio_client(parametros) as (leer, escribir):
        async with ClientSession(leer, escribir) as sesion:
            await sesion.initialize()
            print("herramientas:", [t.name for t in (await sesion.list_tools()).tools])
            print("recursos:", [str(r.uri) for r in (await sesion.list_resources()).resources])
            print("prompts:", [p.name for p in (await sesion.list_prompts()).prompts])
            busqueda = await sesion.call_tool("buscar_libros", {"texto": "cortazar", "limite": 3})
            print("buscar_libros:", " ".join(c.text for c in busqueda.content))
            validacion = await sesion.call_tool("validar_catalogo", {})
            print("validar_catalogo:", validacion.content[0].text)


if __name__ == "__main__":
    asyncio.run(main())
