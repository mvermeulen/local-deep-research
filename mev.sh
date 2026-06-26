#!/bin/bash

# mev.sh - Helper script for Local Deep Research (CPU-mode)

COMMAND=$1
shift

if [ "$EUID" -ne 0 ]; then
    echo "==========================================================="
    echo " ❌ ERROR: Docker requires administrator privileges."
    echo " Please run this script with sudo:"
    if [ -z "$COMMAND" ]; then
        echo "    sudo ./mev.sh"
    else
        echo "    sudo ./mev.sh $COMMAND"
    fi
    echo "==========================================================="
    exit 1
fi

function show_help {
    echo "Usage: ./mev.sh [command]"
    echo ""
    echo "Commands:"
    echo "  start         - Start the Local Deep Research stack in the background"
    echo "  stop          - Stop the stack"
    echo "  restart       - Restart the stack"
    echo "  logs          - Tail the logs of all services"
    echo "  status        - Show the status of running containers"
    echo "  pull <model>  - Pull an Ollama model (e.g. ./mev.sh pull gemma3:12b)"
    echo "  update        - Pull latest images and restart"
}

case $COMMAND in
    start)
        echo "Starting Local Deep Research stack..."
        docker-compose up -d
        echo "Dashboard will be available at http://localhost:5000"
        ;;
    stop)
        echo "Stopping Local Deep Research stack..."
        docker-compose down
        ;;
    restart)
        echo "Restarting Local Deep Research stack..."
        docker-compose down
        docker-compose up -d
        ;;
    logs)
        docker-compose logs -f
        ;;
    status)
        docker-compose ps
        ;;
    pull)
        MODEL=$1
        if [ -z "$MODEL" ]; then
            echo "Please provide a model name, e.g., ./mev.sh pull gemma3:12b"
            exit 1
        fi
        echo "Pulling model $MODEL via host Ollama..."
        ollama pull "$MODEL"
        ;;
    update)
        echo "Pulling latest Docker images..."
        docker-compose pull
        echo "Restarting services..."
        docker-compose up -d
        ;;
    *)
        show_help
        ;;
esac
