# Qdrant Folder

This folder contains scripts and configuration for managing and populating your Qdrant vector database instance.

## Scripts

- **upload_jira_csv_to_qdrant.py**
  - Uploads Jira issues from a CSV file to your Qdrant instance.
  - Uses OpenAI embeddings for vectorization.
  - Supports resuming from a specific row in the CSV.

- **sanity-test.py**
  - Checks connectivity to your Qdrant instance.
  - Lists available collections and performs a sample similarity search using OpenAI embeddings.

- **nuke_qdrant.py**
  - Deletes all collections in your Qdrant instance after user confirmation.
  - Use with caution: this will irreversibly remove all data.

- **.env-example**
  - Example environment variable file.
  - Copy to `.env` and fill in your actual Qdrant and OpenAI credentials.

## Usage
- Install dependencies from `requirements.txt`.
- Configure your `.env` file as needed.
- Run the scripts as described above for data upload, testing, or cleanup. 