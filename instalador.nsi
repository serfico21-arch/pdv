; Instalador do FCosta Gestor (NSIS). Construído automaticamente pelo GitHub Actions
; (veja .github/workflows/construir-instalador.yml) ou localmente com instalador/construir.sh
Unicode true
SetCompressor /SOLID lzma
!include "MUI2.nsh"

!ifndef APP_VERSAO
  !define APP_VERSAO "0.0.0"
!endif
!define APP_NOME "FCosta Gestor"

Name "${APP_NOME}"
OutFile "../FCostaGestor-Instalador.exe"
InstallDir "$PROGRAMFILES\FCosta Gestor"
InstallDirRegKey HKLM "Software\FCosta Gestor" "Install_Dir"
RequestExecutionLevel admin
BrandingText "${APP_NOME} ${APP_VERSAO}"

VIProductVersion "${APP_VERSAO}.0"
VIAddVersionKey /LANG=1046 "ProductName" "${APP_NOME}"
VIAddVersionKey /LANG=1046 "CompanyName" "FCosta Gestor"
VIAddVersionKey /LANG=1046 "FileDescription" "Instalador do ${APP_NOME}"
VIAddVersionKey /LANG=1046 "FileVersion" "${APP_VERSAO}"
VIAddVersionKey /LANG=1046 "ProductVersion" "${APP_VERSAO}"
VIAddVersionKey /LANG=1046 "LegalCopyright" "FCosta Gestor"

!define MUI_ICON "icon.ico"
!define MUI_UNICON "icon.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "modern-wizard.bmp"
!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_RUN "$INSTDIR\fcosta-gestor.html"
!define MUI_FINISHPAGE_RUN_TEXT "Abrir o FCosta Gestor agora"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "PortugueseBR"

Section "Instalar"
  SetOutPath "$INSTDIR"
  File "../fcosta-gestor.html"
  File "icon.ico"
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  CreateShortcut "$DESKTOP\FCosta Gestor.lnk" "$INSTDIR\fcosta-gestor.html" "" "$INSTDIR\icon.ico"
  CreateDirectory "$SMPROGRAMS\FCosta Gestor"
  CreateShortcut "$SMPROGRAMS\FCosta Gestor\FCosta Gestor.lnk" "$INSTDIR\fcosta-gestor.html" "" "$INSTDIR\icon.ico"
  CreateShortcut "$SMPROGRAMS\FCosta Gestor\Desinstalar.lnk" "$INSTDIR\Uninstall.exe"

  WriteRegStr HKLM "Software\FCosta Gestor" "Install_Dir" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FCostaGestor" "DisplayName" "${APP_NOME}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FCostaGestor" "UninstallString" '"$INSTDIR\Uninstall.exe"'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FCostaGestor" "DisplayIcon" "$INSTDIR\icon.ico"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FCostaGestor" "DisplayVersion" "${APP_VERSAO}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FCostaGestor" "Publisher" "FCosta Gestor"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FCostaGestor" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FCostaGestor" "NoRepair" 1
SectionEnd

Section "Uninstall"
  Delete "$DESKTOP\FCosta Gestor.lnk"
  Delete "$SMPROGRAMS\FCosta Gestor\FCosta Gestor.lnk"
  Delete "$SMPROGRAMS\FCosta Gestor\Desinstalar.lnk"
  RMDir "$SMPROGRAMS\FCosta Gestor"
  Delete "$INSTDIR\fcosta-gestor.html"
  Delete "$INSTDIR\icon.ico"
  Delete "$INSTDIR\Uninstall.exe"
  RMDir "$INSTDIR"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FCostaGestor"
  DeleteRegKey HKLM "Software\FCosta Gestor"
SectionEnd
