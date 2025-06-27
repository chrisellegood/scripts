#!/bin/bash

# File: setup_ollama_gpu.sh

# Add OLLAMA_GPU setting to .bashrc if it's not already there
if ! grep -q "OLLAMA_GPU=1" ~/.bashrc; then
  echo "export OLLAMA_GPU=1" >> ~/.bashrc
  echo "Added 'export OLLAMA_GPU=1' to ~/.bashrc"
fi

# Add an alias to ensure ollama always runs with GPU
if ! grep -q "alias ollama=" ~/.bashrc; then
  echo "alias ollama='OLLAMA_GPU=1 ollama'" >> ~/.bashrc
  echo "Added alias to ~/.bashrc"
fi

# Reload shell configuration
source ~/.bashrc

# Confirm setup
echo "✔️  GPU support for Ollama configured."
echo
echo "To verify it's working, run a model:"
echo "    ollama run llama3"
echo "Then check GPU usage with:"
echo "    nvidia-smi"
