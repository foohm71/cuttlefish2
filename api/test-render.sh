#!/bin/bash

# Load API_URL and OPENAI_API_KEY from .env if available
if [ -f .env ]; then
  export $(grep -v '^#' .env | grep -E 'API_URL|OPENAI_API_KEY' | xargs)
fi

# Fallback to hardcoded values if not set
API_URL="${API_URL:-https://cuttlefish2.onrender.com}"
OPENAI_API_KEY="${OPENAI_API_KEY:-}"  # Set your key in .env if not set here
QUERY="All the Null Pointer Exceptions (NPE)"

# For Render, endpoints are available at your Render service URL

# Test /similar endpoint
echo "Testing /similar endpoint..."
curl -s -X POST "$API_URL/similar" \
    -H "Content-Type: application/json" \
    -d "$(jq -n --arg query "$QUERY" --arg key "$OPENAI_API_KEY" '{query: $query, openai_api_key: $key}')" | jq

echo "\nTesting /rag endpoint..."
curl -s -X POST "$API_URL/rag" \
    -H "Content-Type: application/json" \
    -d "$(jq -n --arg query "$QUERY" --arg key "$OPENAI_API_KEY" '{query: $query, openai_api_key: $key}')" | jq 
