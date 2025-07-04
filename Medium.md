<p align="center">
  <img src="frontend/public/cuttlefish.svg" alt="Cuttlefish Logo" width="120" />
</p>

# Building Cuttlefish2: A Modern Jira Bug Similarity Engine with RAG and UI

## Background

In my previous article, ["Building a Deployable Jira Bug Similarity Engine using Word Embedding and Cosine Similarity"](https://medium.com/data-science/building-a-deployable-jira-bug-similarity-engine-using-word-embedding-and-cosine-similarity-1c78eeb23a8d), I described how I used AWS BlazingText to generate word embeddings from a large corpus of Jira bug reports. The core idea was to represent each bug as a vector in a high-dimensional space, then use cosine similarity to find similar bugs. The project, [Cuttlefish](https://gitlab.com/foohm71/cuttlefish), was a proof-of-concept that showed how word embeddings and simple vector math could be used to build a practical bug similarity engine.

The process involved:
- Generating word embeddings with BlazingText and saving them as `vectors.txt`.
- Preprocessing Jira bug data (title + description) into feature vectors.
- Using cosine similarity to compare bugs and surface the most similar ones.
- Wrapping the logic in a simple Flask API and deploying as a Docker container.

The data came from open source JIRA archives, with the main dataset (`JIRA_OPEN_DATA_LARGESET.csv`) containing over 41,000 entries ([see here for more on the data](https://gitlab.com/foohm71/octopus2#the-data)).

**But there were some limitations:**
- The embedding model was static and required AWS infrastructure.
- The retrieval was done in-memory, not scalable for large datasets.
- There was no RAG (Retrieval-Augmented Generation) or modern UI for experimentation.

**Enter Cuttlefish2.**

The goal of Cuttlefish2 is to rebuild the bug similarity engine from scratch, but with a modern stack:
- Use OpenAI's embedding model for vectorization.
- Store and search embeddings in [Qdrant](https://qdrant.tech/), a production-grade vector database.
- Build a FastAPI backend with endpoints for similarity search and RAG.
- Create a Next.js frontend UI for interactive exploration.
- Deploy the backend on Render and the frontend on Vercel.

## Setting up the Vector Database

The first step was to set up a vector database. I chose Qdrant for its ease of use and cloud offering.

> **Prompt:**
>
> Set up a Qdrant Cloud instance and confirm connectivity.

After creating a Qdrant Cloud instance, I needed to upload the Jira bug data as vectors. This involved a bit of "vibe coding"—iteratively prompting and generating scripts to:
- Read `JIRA_OPEN_DATA_LARGESET.csv`.
- Generate OpenAI embeddings for each bug (title + description).
- Upsert the vectors into Qdrant, with all other fields as metadata.

> **Prompt:**
>
> Write a script (`upload_jira_csv_to_qdrant.py`) to read a Jira CSV, generate OpenAI embeddings, and upsert them into Qdrant. Use a `.env` file for configuration.

The script was improved to handle batching, retries, and token limits. I also added:
- A `sanity-test.py` script to check Qdrant connectivity and perform a sample similarity search.
- A `nuke_qdrant.py` script to delete all Qdrant collections after confirmation.

## Vibe Coding the API (FastAPI)

With the data in Qdrant, the next step was to build an API. I chose FastAPI for its modern features and async support.

> **Prompt:**
>
> Build a FastAPI backend with two endpoints:
> - `/similar`: POST, takes `query` and `openai_api_key`, returns top 5 similar entries from Qdrant.
> - `/rag`: POST, same input, retrieves top 5 similar entries and uses OpenAI's chat/completions API to answer the query using those entries as context.

I added CORS middleware for frontend integration and logging for debugging. To validate the endpoints, I wrote a `test.sh` script:

> **Prompt:**
>
> Create a `test.sh` script to test both endpoints with sample queries and API keys.

This made it easy to check that both `/similar` and `/rag` were working as expected.

## Vibe Coding the Frontend (Next.js)

For the UI, I scaffolded a Next.js app in the `frontend` folder. The main page included:
- An input for the OpenAI API key (saved to localStorage).
- A large query input field.
- "Similarity" and "RAG" buttons to call the FastAPI endpoints.
- Results display, loading, and error handling.

> **Prompt:**
>
> Build a Next.js frontend with a simple UI for querying the backend, styled with Tailwind CSS.

I initially tried Chakra UI for styling, but ran into issues with missing exports and context errors. I reverted to Tailwind CSS, which worked well and kept the UI clean and modern.

Some challenges faced:
- CORS errors (fixed by adding CORS middleware to FastAPI).
- Chakra UI version/context issues (solved by reverting to Tailwind).
- Handling long context and token limits with OpenAI (fixed by truncating input).
- Ensuring the frontend and backend could communicate across different hosts (solved with environment variables and CORS).

## Deployment

- **API:** Deployed on [Render](https://render.com/) as a persistent web service. Start command: `uvicorn main:app --host 0.0.0.0 --port 10000`.
- **Frontend:** Deployed on [Vercel](https://vercel.com/) with the project root set to `frontend/`.
- Environment variables were set in both platforms for API URLs and keys.

## Vibe Checking (Trials)



## Lessons Learned

- **Automated tests and scripts are invaluable.** Having `test.sh` and `test-render.sh` made it easy to validate endpoints after every change.
- **TypeScript/ESLint strictness can block builds.** Next.js (on Vercel) enforces strict linting; using `any` types caused build failures until all were replaced with proper interfaces.
- **Frontend-backend integration needs careful CORS and environment variable management.** CORS issues and hardcoded URLs were common pain points.
- **Framework/library version mismatches can cause subtle bugs.** Chakra UI and Next.js/Tailwind had breaking changes that required rollbacks or rework.
- **Vector DBs like Qdrant make large-scale similarity search practical.** The move from in-memory to Qdrant enabled scaling to tens of thousands of bugs.
- **Prompt-driven development is iterative.** Many features and fixes were "vibe coded"—prompt, generate, test, repeat.
- **Deployment platforms have quirks.** Vercel and Render each have their own requirements for start commands, environment variables, and build output.

---

*For more on the original approach, see the [Medium article](https://medium.com/data-science/building-a-deployable-jira-bug-similarity-engine-using-word-embedding-and-cosine-similarity-1c78eeb23a8d) and [Cuttlefish GitLab repository](https://gitlab.com/foohm71/cuttlefish).* 