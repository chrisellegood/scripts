# 🧠 Accelerating Ollama with GPU on Linux (RTX 4070)

This guide walks you through setting up GPU acceleration for [Ollama](https://ollama.com) using an NVIDIA GPU (like the RTX 4070) on a Linux system.

---

## ✅ Why Use GPU?

Running large language models (LLMs) on a GPU gives:

- 🚀 Faster response times
- 🌡️ Lower CPU load
- 🔋 Better energy efficiency

---

## 📦 What You Need

- 🖥️ A compatible NVIDIA GPU (e.g., RTX 4070 with 12GB VRAM)
- ✅ Working NVIDIA drivers & CUDA (confirmed with `nvidia-smi`)
- 🧰 Ollama installed (`https://ollama.com/download`)

---

## 🔧 Setup Instructions

1. **Download the setup script:**
   [setup_ollama_gpu.sh](./setup_ollama_gpu.sh)

2. **Make the script executable:**

   ```bash
   chmod +x setup_ollama_gpu.sh
   ```

3. **Run the script:**

   ```bash
   ./setup_ollama_gpu.sh
   ```

   This will:
   - Set the environment variable `OLLAMA_GPU=1`
   - Add an alias so every `ollama` call uses the GPU
   - Apply changes immediately

---

## 🧪 Verify GPU Usage

1. Start a model:

   ```bash
   ollama run llama3
   ```

2. In another terminal, run:

   ```bash
   nvidia-smi
   ```

You should see something like:

```
/usr/local/bin/ollama    5894MiB
```

---

## 🧼 Notes

- The setup modifies `~/.bashrc`
- If you use Zsh, replicate the steps in `~/.zshrc`
- Works across reboots and terminal sessions

---

## 📁 Files

- `setup_ollama_gpu.sh`: Automates configuration
- `GPU_SETUP_GUIDE.md`: This guide

---

Happy prompting! 🚀
