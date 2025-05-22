#!/bin/bash

set -e  # Exit immediately if any command exits with a non-zero status

cd backend || { echo "Failed to enter backend directory"; exit 1; }

echo "Python version:"
python3 --version

echo "Creating virtual environment..."
python3 -m venv venv || { echo "Failed to create virtual environment"; exit 1; }

echo "Activating virtual environment..."
source venv/bin/activate || { echo "Failed to activate virtual environment"; exit 1; }

echo "Downgrading pip to version compatible with Python 3.6..."
pip install --upgrade "pip<21.0" setuptools wheel || { echo "Failed to downgrade pip"; exit 1; }

echo "Pip version after downgrade:"
pip --version

echo "Installing dependencies from requirements.txt..."
# First try with original requirements
if ! pip install -r requirements.txt; then
    echo "First attempt failed, trying with downgraded packages..."
    
    # Create temporary downgraded requirements
    cat > temp_requirements.txt << 'EOL'
fastapi==0.68.0
uvicorn==0.15.0
pydantic==1.8.2
python-multipart==0.0.5
aiohttp==3.7.4
sqlalchemy==1.4.46
python-jose==3.3.0
passlib[bcrypt]==1.7.4
PyJWT[crypto]==2.3.0
loguru==0.6.0
EOL

    if ! pip install -r temp_requirements.txt; then
        echo "Failed to install even with downgraded packages"
        echo "Your Python 3.6 environment is too old for these dependencies"
        echo "Please upgrade to Python 3.9+ or use Docker instead"
        rm -f temp_requirements.txt
        exit 1
    fi
    rm -f temp_requirements.txt
fi

echo "Starting backend server..."
nohup python3 main.py &> ../../openwebui.log &

echo "Deployment completed. Check openwebui.log for server output."
