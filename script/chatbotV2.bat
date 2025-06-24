@echo off
REM Changer la page de code pour UTF-8
chcp 65001 >nul 
REM mise en place de variables d'environnement
setlocal 

echo ===============================
echo Selection du chatbot a lancer :
echo ===============================
echo [1] Chatbot (RAG only)
echo [2] Chatbot (Orchester)
echo ===============================

set /p choice="Entrez le numero du chatbot : "

REM Rediriger selon le choix
if "%choice%"=="1" (
    cd /d "..\chatbot(RAG only)"
    python rag.py
) else if "%choice%"=="2" (
    cd /d "..\Chatbot(Orchester)"
    python main.py
) else (
    echo Choix invalide. Veuillez relancer le script.
    pause
)
REM Gestion des erreurs
if errorlevel 1 (
    echo Erreur lors de l'exécution du script Python.
    pause
) else (
    echo Exécution du script Python réussie.
)

