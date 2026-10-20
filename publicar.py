#!/usr/bin/env python3
"""Ferramentas de publicação do FCosta Gestor.
  publicar.py versao      -> imprime a versão (APP_VERSAO) lida do fcosta-gestor.html
  publicar.py publicar    -> gera versao.json e atualiza o código de conferência (SHA-256) no index.html e README.md
"""
import sys, re, json, hashlib, datetime, pathlib

RAIZ = pathlib.Path(__file__).resolve().parent.parent
HTML = RAIZ / "fcosta-gestor.html"
EXE = RAIZ / "FCostaGestor-Instalador.exe"
BASE = "https://github.com/serfico21-arch/pdv/raw/main/"

def versao_do_html():
    m = re.search(r"const\s+APP_VERSAO\s*=\s*'(\d+\.\d+\.\d+)'", HTML.read_text(encoding="utf-8"))
    if not m:
        sys.exit("ERRO: não achei  const APP_VERSAO = 'X.Y.Z'  no fcosta-gestor.html")
    return m.group(1)

def notas():
    arq = RAIZ / "notas-versao.txt"
    if not arq.exists():
        return []
    return [l.strip().lstrip("-•* ").strip() for l in arq.read_text(encoding="utf-8").splitlines() if l.strip()]

def publicar():
    versao = versao_do_html()
    if not EXE.exists():
        sys.exit("ERRO: instalador não encontrado: %s" % EXE)
    sha = hashlib.sha256(EXE.read_bytes()).hexdigest()
    arq_versao = RAIZ / "versao.json"
    if arq_versao.exists():
        try:
            anterior = json.loads(arq_versao.read_text(encoding="utf-8")).get("versao")
            if anterior == versao:
                print("::warning::A versão continua %s. Se você mudou o sistema, aumente APP_VERSAO no fcosta-gestor.html — senão os usuários NÃO serão avisados da atualização." % versao)
        except Exception:
            pass
    dados = {
        "versao": versao,
        "data": datetime.date.today().isoformat(),
        "instalador": BASE + "FCostaGestor-Instalador.exe",
        "html": BASE + "fcosta-gestor.html",
        "sha256": sha,
        "notas": notas(),
    }
    arq_versao.write_text(json.dumps(dados, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    for nome in ("index.html", "README.md"):
        arq = RAIZ / nome
        if not arq.exists():
            continue
        t = arq.read_text(encoding="utf-8")
        t = re.sub(r"(<!--SHA-->)(.*?)(<!--/SHA-->)", lambda m: m.group(1) + sha + m.group(3), t, flags=re.S)
        t = re.sub(r"(<!--VER-->)(.*?)(<!--/VER-->)", lambda m: m.group(1) + versao + m.group(3), t, flags=re.S)
        arq.write_text(t, encoding="utf-8")
    print("versão", versao, "| sha256", sha)

if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else ""
    if cmd == "versao":
        print(versao_do_html())
    elif cmd == "publicar":
        publicar()
    else:
        sys.exit(__doc__)
