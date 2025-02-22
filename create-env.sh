#!/bin/bash

# Check if the environment.yml file exists
if [[ ! -f "env.yml" ]]; then
  echo "Error: env.yml file not found."
  exit 1
fi

# Extract environment name from the yml file (assuming it's defined in the file)
env_name=$(grep "name:" env.yml | awk '{print $2}')

# Check if conda is initialized for the shell
if ! command -v conda &> /dev/null; then
  echo "Conda is not installed or not available in the current shell session."
  exit 1
fi

# Initialize conda for the current shell session if not already initialized
if [[ -z "$CONDA_PREFIX" ]]; then
  echo "Initializing Conda..."
  conda init
  # Restart the shell to apply conda init (the user can manually restart if desired)
  echo "Please restart your shell or run 'source ~/.bashrc' to finalize the initialization."
  exit 1
fi

# Check if the environment already exists
conda env list | grep -q "$env_name"

if [[ $? -eq 0 ]]; then
  echo "Updating existing Conda environment: $env_name"
  conda env update --file env.yml --prune
else
  echo "Creating new Conda environment: $env_name"
  conda env create --file env.yml
fi

# Activate the environment
echo "Activating environment: $env_name"
conda activate "$env_name"
