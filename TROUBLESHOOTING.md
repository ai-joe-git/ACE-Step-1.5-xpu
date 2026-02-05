# ACE-Step XPU Troubleshooting Guide

Common issues and solutions for Intel Arc GPU users.

## Installation Issues

### Python Not Found

**Error**: `'python' is not recognized`

**Solution**:
1. Reinstall Python with "Add to PATH" checked
2. Or add manually:
   - Search "Environment Variables"
   - Edit PATH, add: `C:\Users\[username]\AppData\Local\Programs\Python\Python311`
3. Restart terminal

### Virtual Environment Fails

**Error**: `venv creation failed`

**Solution**:
```cmd
python -m pip install --upgrade pip
python -m pip install virtualenv
python -m venv venv --clear
```

### PyTorch XPU Install Fails

**Error**: Package conflicts or download failures

**Solution**:
```cmd
pip install --upgrade pip
pip cache purge
pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/xpu --force-reinstall
```

## GPU Issues

### XPU Not Detected

**Symptoms**: Fallback to CPU, very slow generation

**Check GPU**:
```cmd
python -c "import torch; print('XPU available:', torch.xpu.is_available()); print('XPU device count:', torch.xpu.device_count())"
```

Should show: `XPU available: True`

**Solutions**:

1. **Update Drivers**:
   - Download: https://www.intel.com/content/www/us/en/download/785597/
   - Install and restart

2. **Check Device Manager**:
   - Win+X → Device Manager
   - Display adapters → Intel Arc
   - Should not have yellow warning icon

3. **Verify Driver Version**:
   - Right-click Arc GPU → Properties → Driver
   - Should be 32.0.101.xxxx or newer

4. **Reinstall Intel Extension**:
```cmd
call venv\Scripts\activate
pip uninstall intel-extension-for-pytorch -y
pip install intel-extension-for-pytorch
```

### Slow Performance

**Expected speeds** (Arc A770):
- Turbo + 1.7B: 30-45 seconds per 2-minute track
- Base + 4B: 2-3 minutes per 2-minute track

**If slower**:
1. Check GPU usage in Task Manager (should be 90-100%)
2. Close Chrome, games, other GPU apps
3. Disable hardware acceleration in browsers
4. Check temperatures (should be under 80°C)

### Out of Memory Errors

**Error**: `RuntimeError: out of memory`

**Solutions**:
1. Reduce batch size to 1
2. Enable CPU offload in UI settings
3. Use Turbo instead of Base model
4. Lower max audio duration to 60-120 seconds
5. Close other applications

**Memory usage** (Arc A770 16GB):
- Turbo + 1.7B: ~6-8 GB VRAM
- Base + 4B: ~12-14 GB VRAM

## Model Download Issues

### Download Timeout

**Error**: `Read timed out` or `IncompleteRead`

**Solutions**:

1. **Run robust downloader**:
```batch
@echo off
call venv\Scripts\activate
:retry
python -c "from huggingface_hub import snapshot_download; snapshot_download('ACE-Step/acestep-v15-base', local_dir='checkpoints/acestep-v15-base', max_workers=1)"
if errorlevel 1 (
    echo Retrying in 10 seconds...
    timeout /t 10
    goto retry
)
```

2. **Manual browser download**:
   - Go to HuggingFace model page
   - Download large .safetensors files via browser
   - Place in correct checkpoint folder

3. **Download during off-peak hours**:
   - Night time usually faster
   - HuggingFace CDN is US-based

### Models Not Appearing in UI

**Issue**: Dropdown only shows Turbo, not Base

**Solutions**:

1. **Check folder names**:
   - Should be: `acestep-v15-base` (not `acestep-v15`)
   - Should be: `acestep-v15-turbo`

2. **Verify config.json**:
   - Each model folder needs `config.json`
   - Check: `checkpoints\acestep-v15-base\config.json` exists

3. **Restart UI completely**:
   - Close terminal running the UI
   - Run `run_xpu.bat` again
   - Refresh browser (F5)

4. **Manual path entry**:
   - Type model name directly in field
   - Press Enter, then Initialize

## Generation Issues

### Audio Not Generated

**Error**: Generation completes but no audio output

**Solutions**:

1. **Check for errors** in terminal:
   - Look for red ERROR messages
   - Common: missing packages

2. **Install missing packages**:
```cmd
call venv\Scripts\activate
pip install torchao vector-quantize-pytorch soundfile
```

3. **Check outputs folder**:
   - Files saved to temp folder
   - Use Download button in UI Results section

### Poor Quality Results

**Issues**: Noise, distortion, repetition

**Improvements**:

1. **Use Base + 4B** for quality
2. **Increase inference steps**: 100-200 for base model
3. **Adjust guidance scale**: Try 7-9
4. **Enable ADG**: In Advanced Settings (base only)
5. **More detailed captions**: Be specific about instruments, mood
6. **Enable "Think" mode**: Uses LM for better structure

### LM Not Working

**Error**: `5Hz LM not initialized`

**Solutions**:

1. **Check initialization**:
   - "Initialize 5Hz LM" checkbox must be checked
   - Click "Initialize Service" button

2. **Verify LM model downloaded**:
   - Check `checkpoints\acestep-5Hz-lm-1.7B` folder exists
   - Should contain model files

3. **Check backend**:
   - Use "pt" (PyTorch) backend, not vllm
   - vllm not supported on Windows XPU

## UI Issues

### UI Won't Start

**Error**: Server doesn't launch

**Solutions**:

1. **Check port availability**:
```cmd
netstat -ano | findstr :7860
```
If port busy, kill process or use different port:
```cmd
python acestep\acestep_v15_pipeline.py --port 7861
```

2. **Check Gradio install**:
```cmd
call venv\Scripts\activate
pip install --upgrade gradio
```

### Browser Can't Connect

**Error**: "Can't reach this page"

**Solutions**:
1. Check terminal shows: "Running on local URL: http://127.0.0.1:7860"
2. Try: http://localhost:7860 instead
3. Disable VPN/proxy
4. Check Windows Firewall

## Warning Messages (Safe to Ignore)

These are **normal and don't affect functionality**:

```
Skipping import of cpp extensions due to incompatible torch version
```
→ torchao optimization, still works without

```
PEFT library not installed. LoRA training will not be available.
```
→ Only needed if training custom models

```
NOTE: Redirects are currently not supported in Windows
```
→ Logging limitation, doesn't affect generation

```
CUDA is not available or torch_xla is imported
```
→ Normal, you're using XPU not CUDA

## Getting Help

If issues persist:

1. **Check terminal output** for specific errors
2. **Search GitHub issues**: Similar problems often solved
3. **Open new issue** with:
   - Full error message
   - Your GPU model
   - Driver version
   - Steps to reproduce

## Performance Benchmarks

**Expected generation times** (Intel Arc A770 16GB):

| Setup | Model | LM | Steps | Track Length | Gen Time |
|-------|-------|----|----|--------------|----------|
| Fast | Turbo | 1.7B | 8 | 120s | ~35s |
| Balanced | Turbo | 4B | 8 | 120s | ~50s |
| Quality | Base | 4B | 50 | 120s | ~120s |
| Studio | Base | 4B | 200 | 120s | ~240s |

If your times are **2-3x slower**, GPU may not be detected properly.

---

**Still stuck?** Open a GitHub issue with details!
