#!/bin/bash

API_URL="http://127.0.0.1:8000"

# Load OPENAI_API_KEY from .env if available
if [ -f .env ]; then
  export $(grep -v '^#' .env | grep OPENAI_API_KEY | xargs)
fi

# Fallback to hardcoded key if not set
OPENAI_API_KEY="${OPENAI_API_KEY:-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}"
QUERY="All the Null Pointer Exceptions (NPE)"

# For local testing, ensure FastAPI is running:
#   uvicorn main:app --reload
# For Vercel, the handler will be used automatically.

# Test /similar endpoint
echo "Testing /similar endpoint..."
curl -s -X POST "$API_URL/similar" \
    -H "Content-Type: application/json" \
    -d "$(jq -n --arg query "$QUERY" --arg key "$OPENAI_API_KEY" '{query: $query, openai_api_key: $key}')" | jq

echo "\nTesting /rag endpoint..."
curl -s -X POST "$API_URL/rag" \
    -H "Content-Type: application/json" \
    -d "$(jq -n --arg query "$QUERY" --arg key "$OPENAI_API_KEY" '{query: $query, openai_api_key: $key}')" | jq 
