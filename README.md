# FCosta Gestor (PDV)

Gestor de frente de caixa, estoque e financeiro. Funciona offline, no navegador do computador.

- **Instalador (Windows):** `FCostaGestor-Instalador.exe`
- **Sistema sem instalar:** `fcosta-gestor.html`
- **Página de download e instruções:** `index.html`
- **Versão atual:** <!--VER-->2.4.0<!--/VER-->

## Conferir o instalador

```
certutil -hashfile FCostaGestor-Instalador.exe SHA256
```

Deve resultar em: `<!--SHA-->0783a53b8f2e1e5c43dfe57b6f0824b198ea3e941957b9026a9f1e8ba071168f<!--/SHA-->`

## Atenção com os dados

Os dados ficam no navegador do computador. Use sempre o mesmo navegador e perfil, configure a pasta de backup automático em **Cadastros → Impressora & Backup** e baixe backups completos com frequência.

## Como publicar uma melhoria (para quem mantém o sistema)

O instalador e o aviso de atualização são gerados sozinhos. Você só precisa de 3 passos:

1. **Edite o `fcosta-gestor.html`** e **aumente a versão** na linha `const APP_VERSAO = '2.3.0';` (ex.: `2.4.0`). Se não aumentar, os usuários não são avisados.
2. **Escreva as novidades** em `notas-versao.txt` (uma por linha). Elas aparecem para o usuário na tela de atualização.
3. **Suba os dois arquivos** no GitHub (Add file → Upload files, ou o lápis para editar) e confirme em *Commit changes*.

Em 1 a 2 minutos, a aba **Actions** mostra "Construir instalador" em verde e, sozinhos, são atualizados: `FCostaGestor-Instalador.exe`, `versao.json` e o código de conferência acima.

Nos computadores dos usuários, o sistema verifica `versao.json` ao abrir e a cada 6 horas (ou quando clicam em *Verificar atualizações agora*), e mostra **🔄 Atualização** no topo.

### Configuração única (só na primeira vez)

Em **Settings → Actions → General → Workflow permissions**, marque **Read and write permissions** e salve.

### Se a aba Actions ficar vermelha

Abra a execução com erro e leia a última linha do log. Os motivos mais comuns: faltou `const APP_VERSAO = 'X.Y.Z'` no HTML, ou a permissão acima não foi ativada.

### Estrutura

| Arquivo | Para que serve |
| --- | --- |
| `fcosta-gestor.html` | O sistema (o que você edita) |
| `notas-versao.txt` | Novidades mostradas ao usuário |
| `versao.json` | Gerado sozinho: versão mais nova (o sistema lê este arquivo) |
| `FCostaGestor-Instalador.exe` | Gerado sozinho a partir do HTML |
| `instalador.nsi`, `icon.ico`, `modern-wizard.bmp`, `construir.sh`, `publicar.py` | Script do instalador, ícone, imagem e ferramentas de build |
| `.github/workflows/construir-instalador.yml` | Receita da construção automática |
