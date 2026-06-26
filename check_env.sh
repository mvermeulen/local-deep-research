#!/bin/bash

# check_env.sh - Pre-requisite checker for Local Deep Research

echo "=================================================="
echo " Checking Local Deep Research Prerequisites"
echo "=================================================="

# 1. Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed."
else
    echo "✅ Docker is installed."
fi

# 2. Check for docker-compose or docker compose
if command -v docker-compose &> /dev/null; then
    echo "✅ docker-compose is installed."
elif docker compose version &> /dev/null; then
    echo "✅ docker compose plugin is installed."
else
    echo "❌ Neither docker-compose nor docker compose plugin found."
fi

# 3. Check if Ollama is installed
if ! command -v ollama &> /dev/null; then
    echo "❌ Ollama is not installed on the host."
else
    echo "✅ Ollama is installed."
fi

# 4. Check if Ollama is running and accessible
if curl -s http://localhost:11434 > /dev/null; then
    echo "✅ Ollama service is running and responding."
else
    echo "❌ Ollama service is not responding on port 11434."
fi

# 5. Check if Ollama is configured for Docker access (OLLAMA_HOST=0.0.0.0)
# We check systemctl cat for the environment variable
if systemctl cat ollama 2>/dev/null | grep -q 'OLLAMA_HOST=0.0.0.0'; then
    echo "✅ Ollama is configured to allow Docker connections (OLLAMA_HOST=0.0.0.0)."
else
    echo "❌ Ollama is NOT configured to allow Docker connections."
    echo "   -> Run: sudo systemctl edit ollama"
    echo "   -> Add: Environment=\"OLLAMA_HOST=0.0.0.0\""
    echo "   -> Run: sudo systemctl restart ollama"
fi

echo "=================================================="
echo " Pre-requisite check complete!"
echo "=================================================="
