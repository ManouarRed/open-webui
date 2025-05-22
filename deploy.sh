#!/bin/bash

set -e  # Exit immediately if any command exits with a non-zero status

cd backend || { echo "Failed to enter backend directory"; exit 1; }

echo "Python version:"
python3 --version

echo "Creating virtual environment..."
python3 -m venv venv || { echo "Failed to create virtual environment"; exit 1; }

echo "Activating virtual environment..."
source venv/bin/activate || { echo "Failed to activate virtual environment"; exit 1; }

echo "Upgrading pip, setuptools, and wheel..."
pip install --upgrade pip setuptools wheel || { echo "Failed to upgrade pip"; exit 1; }

echo "Pip version after upgrade:"
pip --version

echo "Installing dependencies from requirements.txt..."
# First try with the original requirements
if ! pip install -r requirements.txt; then
    echo "Failed with original requirements, trying with pydantic 1.9.2..."
    # Create a temporary requirements file with older pydantic
    sed 's/pydantic==1.10.12/pydantic==1.9.2/' requirements.txt > temp_requirements.txt
    pip install -r temp_requirements.txt || { echo "Failed to install dependencies"; exit 1; }
    rm temp_requirements.txt
fi

echo "Starting backend server..."
nohup python3 main.py &> ../../openwebui.log &
