"""Hook PostToolUse: formatea y analiza el archivo .dart que se acaba de editar."""
import json
import shutil
import subprocess
import sys
from pathlib import Path

PROYECTO = Path(__file__).resolve().parents[2]


def main() -> int:
    try:
        datos = json.load(sys.stdin)
        archivo = Path(datos["tool_input"]["file_path"]).resolve()
    except (ValueError, KeyError, TypeError):
        return 0
    # Solo archivos Dart de este proyecto.
    if archivo.suffix != ".dart" or PROYECTO not in archivo.parents:
        return 0
    dart = shutil.which("dart")
    if dart is None or not archivo.exists():
        return 0
    subprocess.run([dart, "format", str(archivo)], cwd=PROYECTO, capture_output=True)
    analisis = subprocess.run(
        [dart, "analyze", str(archivo)],
        cwd=PROYECTO,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
    )
    if analisis.returncode != 0:
        # Código 2: el mensaje vuelve a Claude para que lo corrija.
        print(analisis.stdout + analisis.stderr, file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    sys.exit(main())
