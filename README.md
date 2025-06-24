# 🤖 AI Agents Orchestrator

Ce projet est un orchestrateur d'agents d'intelligence artificielle (IA) écrit en Python. Il transforme les requêtes utilisateur en JSON structuré pour appeler dynamiquement des agents IA comme le scraping de site web, le questionnement sur des documents internes (RAG) ou la recherche simple.


## 🚀 Fonctionnalités

- 🔁 Boucle d'interaction continue avec l'utilisateur
- 🧠 Utilisation d’un LLM local (Ollama, LM Studio...) compatible OpenAI API
- 🕷️ `ScraperAgent` : extrait et résume des pages web à partir d’une URL
- 📚 `RagAgent` : interroge des fichiers PDF locaux grâce à un moteur RAG
- 🔎 `SearchAgent` : répond à des questions générales en cherchant avec ddg
- 🔄 Routage intelligent via un LLM qui génère un JSON d'appel d'agent


## 🛠️ Prérequis

- Installer `llama.cpp` (https://github.com/ggml-org/llama.cpp) 
  - Note : la version utilisé ici est CUDA sur Windows
  - Placer le dossier à la racine du projet
  - Modifier le chemin correspondant dans les scripts `lancement_llama-server.bat` (V1 et V2)
- Installer `python3` (voir Microsoft Store ou https://www.python.org/downloads/)
- Installer les dépendances python : `pip install -r requirements.txt`
- Sélectionner le modèle que vous voulez utiliser (https://huggingface.co/lmstudio-community/DeepSeek-R1-0528-Qwen3-8B-GGUF/tree/main)
  - Note : pour les pc plus puissant, vous pouvez utilisez ce modèle : https://huggingface.co/Qwen/Qwen3-30B-A3B-GGUF/tree/main
- Ajouter les modèles dans le dossier `models`
- Si vous utiliser l'exécutable `lancement_llama-serveurV2`, veiller à bien modifier la ligne `set "model_choice=Qwen3-30B-A3B-Q4_K_M.gguf"` par : `set "model_choice=[NOM_DU_MODELE].gguf"`


## 📂 Arborescence du projet

```
Projet/
│
├── chatbot(Orchester)/               ← Code source du chatbot
│   ├── __pycache__/
│   ├── agents/
│   │   ├── rag_agent.py
│   │   ├── rag_engine.py
│   │   ├── scraper_agent.py
│   │   └── search_agent.py
│   ├── utils/
│   │   ├── llm.py
│   │   └── logger.py
│   ├── main.py
│   └── orchestrator.py
│
├── chatbot(Rag only)/                ← Code source du chatbot pour la lecture de pdf uniquement
│   ├── embedding_cache.pkl
│   └── rag.py
│
├── llama-b5620-win-cuda/             ← Binaire local (ex llama-b5620-...)
│   └── llama-server.exe
│
├── models/                           ← Modèles GGUF
│
├── scripts/                          ← Fichiers .bat
│   ├── chatbot.bat
│   ├── chatbotV2.bat
│   ├── lancement_llama-server.bat
│   └── lancement_llama-serverV2.bat
│
├── source/                           ← PDF pour le RAG
│   └── *.pdf
│
│
├── README.md                         ← Documentation projet
└── requirements.txt                  ← Dépendances Python
```


## 🧠 Fonctionnement

1. L'utilisateur pose une question naturelle (ex: "Résume cette page https://...").
2. Le LLM génère une structure JSON du type :

```json
{
  "function": "scraper",
  "params": {
    "url": "https://fr.wikipedia.org/wiki/Jeanne_d%27Arc",
    "question": "Résume cette page"
  }
}
```

3. L’orchestrateur appelle l’agent concerné avec les bons paramètres.
4. L’agent exécute sa tâche et retourne une réponse affichée à l’utilisateur.


## 📌 Règles de routage appliquées par le LLM

- Si la question concerne une **URL**, utilise `"function": "scraper"` avec `"url"` et `"question"`.
- Si elle concerne un sujet à traiter **exclusivement à partir des documents internes**, utilise `"function": "rag"` avec `"question"`.
- Si c’est une **question générale sans URL ni référence aux documents internes**, utilise `"function": "search"` avec `"question"`.



## ▶️ Utilisation

- Lancer l'exécutable `lancement_llama-serverV2.bat`
- Lancer ensuite l'exécutable `chatbotV2.bat`

Puis, interagir avec l'orchestrateur :

```text
>> Résume cette page https://fr.wikipedia.org/wiki/Jeanne_d%27Arc
```

Taper `exit` ou `quit` pour sortir.\
Taper `help` pour obtenir de l'aide.


## 💬 Exemples de requêtes

| Type       | Exemple de question                                                        |
|------------|----------------------------------------------------------------------------|
| Scraper    | Résume cette page https://fr.wikipedia.org/wiki/Jeanne_d%27Arc             |
| RAG        | À partir des documents internes, explique-moi ce qu'est la cybersécurité ? |
| Search     | À quoi sert l'intelligence artificielle ?                                  |


## 📄 Licence

MIT — Utilisation libre et gratuite

Créé par [Léo Vandenberghe](https://github.com/PhantomSKZT), [Cyril D'houdetot](https://github.com/DHoudetot-Cyril), [Alexis Druon](https://github.com/MarioSwitch)