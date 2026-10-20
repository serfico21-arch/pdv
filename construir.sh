#!/usr/bin/env bash
# Constrói o instalador (Linux/macOS/WSL). Requer: nsis (makensis) e python3. Opcional: 7zip para conferir.
set -euo pipefail
cd "$(dirname "$0")"
VERSAO="$(python3 publicar.py versao)"
echo ">> Construindo instalador da versão $VERSAO"
makensis -V2 -DAPP_VERSAO="$VERSAO" instalador.nsi
test -s FCostaGestor-Instalador.exe || { echo "ERRO: instalador não foi gerado"; exit 1; }
if command -v 7z >/dev/null 2>&1; then
  7z t FCostaGestor-Instalador.exe | tee /tmp/7z-teste.txt | tail -3
  grep -q "Everything is Ok" /tmp/7z-teste.txt || { echo "ERRO: instalador gerado está com problema"; exit 1; }
  TMP="$(mktemp -d)"; 7z x -y -o"$TMP" FCostaGestor-Instalador.exe >/dev/null
  cmp "$TMP/fcosta-gestor.html" fcosta-gestor.html || { echo "ERRO: HTML dentro do instalador difere do original"; exit 1; }
  rm -rf "$TMP"
fi
python3 publicar.py publicar
echo ">> Pronto."
