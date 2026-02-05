# ACE-Step XPU Setup Guide

Complete installation guide for Intel Arc GPUs.

## Prerequisites

### Hardware Requirements
- **GPU**: Intel Arc A-series (A380/A750/A770) or Arc B-series (B580)
- **VRAM**: 8GB minimum, 16GB recommended
- **RAM**: 16GB minimum, 32GB recommended
- **Storage**: 50GB free space

### Software Requirements
- **Windows 10/11** (64-bit)
- **Python 3.11** (recommended) or 3.10
- **Intel GPU Drivers**: Latest version
  - Download: https://www.intel.com/content/www/us/en/download/785597/
  - Version should be 32.0.101.xxxx or newer

## Step-by-Step Installation

### 1. Verify GPU Drivers

Open Device Manager (Win+X → Device Manager):
- Find "Display adapters"
- Right-click Intel Arc GPU → Properties → Driver
- Check driver version (should be 32.0.101.xxxx+)

If outdated, download and install from Intel website.

### 2. Install Python

Download Python 3.11 from python.org:
- https://www.python.org/downloads/
- During install: **Check "Add Python to PATH"**
- Choose "Install for all users"

Verify installation:
```cmd
python --version
```
Should show: Python 3.11.x

### 3. Download ACE-Step-XPU

Clone or download this repository:
```cmd
git clone https://github.com/[your-username]/ACE-Step-XPU.git
cd ACE-Step-XPU
```

Or download ZIP and extract.

### 4. Run Installation Script

Double-click `install_xpu.bat` or run:
```cmd
install_xpu.bat
```

This will:
- Create Python virtual environment
- Install PyTorch with XPU support
- Install ACE-Step and dependencies
- Ask if you want training packages (optional)

**Installation time**: 10-15 minutes

### 5. Download AI Models

Double-click `download_models.bat` and choose:

**Option 1 - Quick Start** (~8 GB):
- Fast generation
- Good for testing and rapid iteration
- Uses Turbo model + 1.7B LM

**Option 2 - Studio Grade** (~13 GB):
- Best quality output
- Slower but worth it for final production
- Uses Base model + 4B LM

**Option 3 - Complete** (~20 GB):
- Everything included
- Maximum flexibility

**Download time**: 20-90 minutes depending on internet speed

### 6. Launch the UI

Choose one:

**Manual Selection**:
```cmd
run_xpu.bat
```
Then select model in UI

**Quick Mode** (auto-starts Turbo):
```cmd
run_turbo.bat
```

**Studio Mode** (auto-starts Base):
```cmd
run_studio.bat
```

Open browser to: http://127.0.0.1:7860

## First Generation Test

1. In the UI, select **"Simple"** mode
2. Enter: "upbeat rock song with electric guitar"
3. Click **"Create Sample"**
4. Click **"Generate Music"**
5. Wait 30-60 seconds
6. Listen to result in Results section!

## Performance Tips

### For Speed
- Use `run_turbo.bat`
- Keep batch size at 2
- Use 1.7B or 0.6B LM

### For Quality
- Use `run_studio.bat`
- Set inference steps to 100-200
- Use 4B LM
- Enable ADG in Advanced Settings
- Export as FLAC

## Troubleshooting

### "XPU not detected" or slow generation
- Update Intel GPU drivers
- Restart computer after driver install
- Check Task Manager → GPU during generation

### Out of memory errors
- Reduce batch size to 1
- Enable CPU offload in UI
- Close other GPU applications
- Use Turbo model instead of Base

### Downloads fail
- Run download script multiple times (it resumes)
- Check internet connection
- Try downloading during off-peak hours

### UI doesn't start
- Check Python version: `python --version`
- Verify venv activation worked
- Check terminal for error messages

## File Structure

```
ACE-Step-XPU/
├── install_xpu.bat          # One-time installation
├── download_models.bat      # Model downloader
├── run_xpu.bat             # Launch with manual selection
├── run_turbo.bat           # Quick mode launcher
├── run_studio.bat          # Quality mode launcher
├── checkpoints/            # Downloaded models go here
│   ├── acestep-v15-turbo/
│   ├── acestep-v15-base/
│   ├── acestep-5Hz-lm-0.6B/
│   ├── acestep-5Hz-lm-1.7B/
│   └── acestep-5Hz-lm-4B/
└── venv/                   # Python virtual environment
```

## Next Steps

After successful installation:
- Read TROUBLESHOOTING.md for common issues
- Experiment with both Turbo and Base models
- Try different LM sizes to find your preference
- Join community discussions for tips

---

**Questions?** Open an issue on GitHub!
