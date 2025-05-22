#!/bin/bash

cd backend || { echo "Failed to enter backend directory"; exit 1; }

python3 --version

python3 -m venv venv || { echo "Failed to create venv"; exit 1; }

source venv/bin/activate || { echo "Failed to activate venv"; exit 1; }

pip install --upgrade pip setuptools wheel || { echo "Failed to upgrade pip"; exit 1; }

pip install -r requirements.txt || { echo "Failed to install dependencies"; exit 1; }

nohup python3 main.py &> ../../openwebui.log &
