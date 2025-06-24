@echo off
setlocal EnableDelayedExpansion
REM Lancement de llama-server avec choix du modèle et gestion GPU/CPU

REM Définir les chemins
set "LLAMA_PATH=..\llama-b5620-win-cuda"
set "MODELS_DIR=..\models"

REM Choisir un modèle (à adapter éventuellement)
set "model_choice=Qwen3-30B-A3B-Q4_K_M.gguf"
dir 
set "MODEL_PATH=%MODELS_DIR%\%model_choice%"

REM Initialiser les paramètres
set "ngl_param="
set "tokens_param="

REM Choix GPU/CPU
set /p use_gpu="Voulez-vous utiliser le GPU ? (O/N) : "

if /i "!use_gpu!"=="N" (
    REM Mode CPU uniquement
    set "ngl_param=-ngl 0"
    REM Pas de tokens nécessaires
) else (
    REM Mode GPU
    set /p use_defaults="Utiliser les parametres par defaut ? (O/N) : "

    if /i "!use_defaults!"=="N" (
        REM Threads personnalisés
        set /p user_ngl="Nombre de threads (par defaut 30) : "
        if "!user_ngl!"=="" (
            set "user_ngl=30"
        )
        set "ngl_param=-ngl !user_ngl!"

        REM Tokens personnalisés
        set /p user_tokens="Nombre de tokens (par defaut 5000) : "
        if "!user_tokens!"=="" (
            set "user_tokens=5000"
        )
        set "tokens_param=-c !user_tokens!"
    ) else (
        REM Utilisation des paramètres par défaut
        set "ngl_param=-ngl 30"
        set "tokens_param=-c 5000"
    )
)

REM Résumé
echo.
echo === Resume ===
if /i "!use_gpu!"=="N" (
    echo Mode        : CPU
) else (
    echo Mode        : GPU
)
echo Modele      : !MODEL_PATH!
echo Threads     : !ngl_param!
echo Tokens      : !tokens_param!
echo.

REM Lancement du serveur
"%LLAMA_PATH%\llama-server.exe" -m "!MODEL_PATH!" !ngl_param! !tokens_param!
REM gestion des erreurs
if errorlevel 1 (
    echo Erreur lors du lancement de llama-server.
    pause
) else (
    echo Lancement de llama-server reussi.
)
endlocal
