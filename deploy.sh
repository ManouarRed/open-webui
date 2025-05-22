#!/bin/bash

# Navigate to backend folder
cd backend || exit 1

# Set up virtual environment
python3 -m venv venv
source venv/bin/activate

# Upgrade pip and install dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Run the backend
nohup python3 main.py &> ../../openwebui.log &
