@echo off
REM Lancement de llama-server avec Qwen3-30B-A3B-Q4_K_M.gguf et paramètres personnalisés

..\llama-b5620-win-cuda\llama-server.exe -m ..\models\Qwen3-30B-A3B-Q4_K_M.gguf -ngl 20 -c 20000
REM gestion des erreurs
if errorlevel 1 (
    echo Erreur lors du lancement de llama-server.
    pause
) else (
    echo Lancement de llama-server reussi.
)