# Cuttlefish2: Jira Bug Similarity Search, RAG, and UI

## Introduction
This project is a follow up to my article ["Building a Deployable Jira Bug Similarity Engine using Word Embedding and Cosine Similarity"](https://medium.com/data-science/building-a-deployable-jira-bug-similarity-engine-using-word-embedding-and-cosine-similarity-1c78eeb23a8d) and the original [Cuttlefish GitLab repository](https://gitlab.com/foohm71/cuttlefish). In the original project, word embeddings were generated using AWS BlazingText to create a `vectors.txt` file, which was then used for bug similarity search.

In this project, the goal is to build a similar bug similarity engine from scratch, but with several modern enhancements:

- **(a) Use the OpenAI embedding model** for generating vector representations of bug reports.
- **(b) Use Qdrant (a vector database)** for efficient indexing and retrieval of embeddings.
- **(c) Implement Retrieval-Augmented Generation (RAG)** on top of the bug similarity engine, allowing for contextualized answers using OpenAI's language models.
- **(d) Create and deploy a modern UI on Vercel** for interactive experimentation and exploration.

## Data
The input data, `JIRA_OPEN_DATA_LARGESET.csv`, contains over 41,000 entries and is sourced from an open source JIRA archive. For more details on the data, see the [Octopus2 project data section](https://gitlab.com/foohm71/octopus2#the-data).

## Project Structure

- **api/**: FastAPI backend for semantic search and RAG endpoints. See [`api/README.md`](./api/README.md) for details and deployment instructions.
- **frontend/**: Next.js frontend UI for querying the bug similarity engine and RAG. See [`frontend/README.md`](./frontend/README.md) for usage and deployment.
- **qdrant/**: Scripts for data preparation, uploading embeddings to Qdrant, and managing the vector database. See [`qdrant/README.md`](./qdrant/README.md) for setup and usage.

## Running Locally

### 1. Backend (API)
- See [`api/README.md`](./api/README.md) for setup, environment variables, and local running instructions.
- Typical local run command:
  ```bash
  cd api
  pip install -r requirements.txt
  uvicorn main:app --reload
  ```

### 2. Frontend (UI)
- See [`frontend/README.md`](./frontend/README.md) for setup and local dev instructions.
- Typical local run command:
  ```bash
  cd frontend
  npm install
  npm run dev
  ```

### 3. Qdrant Data Preparation
- See [`qdrant/README.md`](./qdrant/README.md) for scripts to upload data, test Qdrant, and manage collections.

## Folder Overviews

- [`api/`](./api/README.md): FastAPI backend for similarity and RAG endpoints.
- [`frontend/`](./frontend/README.md): Next.js frontend for querying and displaying results.
- [`qdrant/`](./qdrant/README.md): Data upload, testing, and management scripts for Qdrant vector DB.

---

For more background, see the [original Medium article](https://medium.com/data-science/building-a-deployable-jira-bug-similarity-engine-using-word-embedding-and-cosine-similarity-1c78eeb23a8d) and [Cuttlefish GitLab repository](https://gitlab.com/foohm71/cuttlefish). 