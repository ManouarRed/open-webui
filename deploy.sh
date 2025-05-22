#!/bin/bash

set -e  # Exit immediately if any command exits with a non-zero status

cd backend || { echo "Failed to enter backend directory"; exit 1; }

echo "Python version:"
python3 --version

echo "Creating virtual environment..."
python3 -m venv venv

echo "Activating virtual environment..."
source venv/bin/activate

echo "Upgrading pip, setuptools, and wheel..."
pip install --upgrade pip setuptools wheel

echo "Pip version after upgrade:"
pip --version

echo "Installing dependencies from requirements.txt..."
pip install -r requirements.txt

echo "Starting backend server..."
nohup python3 main.py &> ../../openwebui.log &
