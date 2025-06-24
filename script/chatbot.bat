@echo off
chcp 65001 >nul
echo ===============================
echo Lancement du projet IA (V2)...
echo ===============================

REM Se déplacer dans le dossier contenant main.py
cd /d "..\chatbot(Orchester)"

REM (Optionnel) Activer l'environnement virtuel
REM call .venv\Scripts\activate

REM Lancer le script Python
python main.py
if errorlevel 1 (
    echo Erreur lors de l'exécution du script Python.
    pause
) else (
    echo Exécution du script Python réussie.
)

echo ===============================
echo Exécution terminée.