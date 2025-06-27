# Complete Ollama + Alpaca Setup Tutorial for Ubuntu

This tutorial will guide you through installing Ollama (AI model server), downloading models, testing the CLI, then setting up Alpaca (GUI client) to work with your Ollama instance.

## Part 1: Installing Ollama

### Download and Install Ollama
```bash
# Download and install Ollama
curl -fsSL https://ollama.com/install.sh | sh
```

### Verify Installation
```bash
# Check if ollama is installed
which ollama

# Check version
ollama --version
```

### Start Ollama Server
```bash
# Start the Ollama server (runs in background)
ollama serve
```

**Note:** Keep this terminal open, or run it in the background. Ollama needs to be running to serve models.

## Part 2: Download and Test Models

### Download a Model
Open a new terminal and download a model:

```bash
# Download a popular model (this will take a few minutes)
ollama pull llama2

# Or download a smaller model for testing
ollama pull llama2:7b

# Or try a coding model
ollama pull codellama

# For advanced users - larger, more capable model
ollama pull deepseek-r1
```

### Test the CLI Interface
```bash
# Start chatting with your model
ollama run llama2

# This opens an interactive chat. Try typing:
# "Hello, how are you?"
# Press Ctrl+D or type /bye to exit
```

### Verify Your Setup
```bash
# List all downloaded models
ollama list

# Check if the API is working
curl http://localhost:11434/api/tags

# Check running processes
ps aux | grep ollama
```

You should see:
- Your downloaded models listed
- JSON response with model information
- Ollama server process running

## Part 3: Installing Alpaca GUI

### Install Flatpak (if not already installed)
```bash
# Install Flatpak
sudo apt update
sudo apt install flatpak

# Add Flathub repository
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

### Install Alpaca
```bash
# Install Alpaca from Flathub
flatpak install flathub com.jeffser.Alpaca
```

### Fix Desktop Integration
After installation, you'll see a message about XDG_DATA_DIRS. To fix this:

**Option 1 (Recommended):** Log out and log back in to your desktop session.

**Option 2:** Update your current session:
```bash
export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:/home/$USER/.local/share/flatpak/exports/share:$XDG_DATA_DIRS"
```

## Part 4: Configure Flatpak Permissions (Critical Step)

### Grant Network Access to Alpaca
```bash
# Give Alpaca network access to connect to local Ollama
flatpak override --user --share=network com.jeffser.Alpaca

# Give broader filesystem access (helps with localhost connections)
flatpak override --user --filesystem=host com.jeffser.Alpaca
```

### Verify Permissions
```bash
# Check what permissions Alpaca has
flatpak info --show-permissions com.jeffser.Alpaca
```

## Part 5: Connect Alpaca to Ollama

### Launch Alpaca
1. Open Alpaca from your applications menu (restart your desktop session first if needed)

### Add Ollama Instance
1. **Look for instance/connection settings** - this might be:
   - A hamburger menu (☰) with "Instances" or "Connections"
   - A "+" or "Add" button
   - Settings/Preferences with an "Instances" tab

2. **Select "Ollama"** (not "Ollama (managed)")

3. **Configure the connection:**
   - **Name:** `Local Ollama` (or any name you prefer)
   - **Instance URL:** Try these in order until one works:
     - `http://127.0.0.1:11434/api`
     - `http://127.0.0.1:11434`
     - `http://localhost:11434/api`
     - `http://localhost:11434`
   - **API Key:** Leave empty
   - **Temperature:** 0.70 (default is fine)
   - **Seed:** 0 (default is fine)

4. **Click "Save"**

### Troubleshooting Connection Issues

If you get "no instances found":

1. **Verify Ollama is running:**
   ```bash
   ps aux | grep ollama
   curl http://localhost:11434/api/tags
   ```

2. **Try different URL formats:**
   - `http://127.0.0.1:11434/api`
   - `http://127.0.0.1:11434`
   - `http://localhost:11434`

3. **Restart Alpaca completely** after changing URLs

4. **Check Flatpak permissions** (make sure you ran the override commands above)

## Part 6: Using Your Setup

### Once Connected Successfully:
- You should see your downloaded models in Alpaca
- Select a model and start chatting
- Your conversations will use your local Ollama server

### Managing Models:
```bash
# Download new models
ollama pull mistral
ollama pull codellama:13b

# Remove models you don't need
ollama rm llama2:7b

# See what's running
ollama ps

# Stop a running model
ollama stop llama2
```

### Useful Commands:
```bash
# Start Ollama server
ollama serve

# Pull a specific model
ollama pull [model-name]

# Chat with a model via CLI
ollama run [model-name]

# List all models
ollama list

# Check API status
curl http://localhost:11434/api/tags
```

## Summary

You now have:
1. ✅ Ollama installed and running locally
2. ✅ AI models downloaded and ready
3. ✅ Alpaca GUI connected to your Ollama instance
4. ✅ A complete local AI setup with no internet dependency for inference

## Key Points to Remember:
- **Ollama must be running** (`ollama serve`) for Alpaca to connect
- **Flatpak permissions are critical** - without them, Alpaca can't access localhost
- **Use "Ollama" not "Ollama (managed)"** to connect to your existing installation
- **Your models and data stay completely local**

## Troubleshooting:
- If Alpaca can't connect: Check Ollama is running and verify the URL format
- If models don't appear: Restart Alpaca after adding the instance
- If downloads are slow: Models are large (several GB each) - be patient
- If you get permission errors: Make sure you ran the Flatpak override commands

Enjoy your local AI setup!