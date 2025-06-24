import os
import fitz  # PyMuPDF
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np
from openai import OpenAI

# --- Client OpenAI-compatible (ex: LM Studio, Ollama, LocalAI, etc.) ---
client = OpenAI(
    api_key="1234",  # Idéalement : os.getenv("OPENAI_API_KEY")
    base_url="http://localhost:8080"
)

# --- Paramètres ---
PDF_DIR = "../source"  # Dossier contenant les PDF
EMBEDDING_MODEL = "intfloat/multilingual-e5-large-instruct"
LLM_MODEL_NAME = "qwen_truc" 

# --- Étape 1 : Chargement des PDF ---
def extract_text_from_pdfs(folder):
    texts = []
    for filename in os.listdir(folder):
        if filename.endswith(".pdf"):
            path = os.path.join(folder, filename)
            with fitz.open(path) as doc:
                text = ""
                for page in doc:
                    text += page.get_text()
                texts.append(text.strip())
    return texts

# --- Étape 2 : Embedding avec préfixe "passage: " ---
def embed_documents(docs, model):
    docs_prefixed = [f"passage: {doc}" for doc in docs]
    return model.encode(docs_prefixed)

# --- Étape 3 : Retrieval par similarité cosinus ---
def retrieve(query, embedder, docs, doc_embeddings, k=2):
    query_embedding = embedder.encode([f"query: {query}"])
    similarities = cosine_similarity(query_embedding, doc_embeddings)[0]
    top_k = np.argsort(similarities)[::-1][:k]
    return [(docs[i], similarities[i]) for i in top_k]

# --- Étape 4 : Génération avec OpenAI-compatible LLM ---
def rag_answer(query, embedder, docs, doc_embeddings, k=2):
    retrieved_docs = retrieve(query, embedder, docs, doc_embeddings, k)
    context = "\n".join([doc for doc, _ in retrieved_docs])

    messages = [
        {"role": "system", "content": "Tu es un assistant qui répond à des questions à partir des documents suivants."},
        {"role": "user", "content": f"Voici les documents :\n{context}\n\nQuestion : {query}"}
    ]

    response = client.chat.completions.create(
        model=LLM_MODEL_NAME,
        messages=messages,
        temperature=0.7,
        max_tokens=500,
        stream=True  # Utiliser le streaming pour des réponses plus rapides
    )

    answer = ""
    print("🧠 Réponse :", end=" ", flush=True)
    for chunk in response:
        delta = chunk.choices[0].delta
        content = delta.content or ""
        print(content, end="", flush=True)
        answer += content
    print()  # retour à la ligne final
    return answer.strip()

# --- Pipeline principal ---
def main():
    print("Chargement des documents PDF...")
    docs = extract_text_from_pdfs(PDF_DIR)

    print("Initialisation de l'embedding model...")
    embedder = SentenceTransformer(EMBEDDING_MODEL)
    doc_embeddings = embed_documents(docs, embedder)

    while True:
        query = input("\nPose ta question (ou 'exit' pour quitter) : ")
        if query.lower() == "exit":
            break
        answer = rag_answer(query, embedder, docs, doc_embeddings)
        print("\n🧠 Réponse :", answer)

if __name__ == "__main__":
    main()