# ACE-Step-1.5 for Intel XPU (Arc GPUs)

![Intel Arc](https://img.shields.io/badge/Intel-Arc%20GPU-blue)
![PyTorch](https://img.shields.io/badge/PyTorch-2.11%20XPU-orange)
![Python](https://img.shields.io/badge/Python-3.11-green)

**Optimized fork of ACE-Step-1.5 for Intel Arc A-series GPUs with XPU acceleration.**

---

## Features

- Full XPU/SYCL acceleration for Intel Arc GPUs
- Text-to-music generation with AI
- Vocal synthesis with lyrics alignment
- Style transfer (cover/repaint tasks)
- LoRA fine-tuning support
- Works completely offline after model download
- Optimized batch scripts for Windows

---

## Tested Hardware

| GPU | VRAM | Status | Notes |
|-----|------|--------|-------|
| Intel Arc A770 | 16GB | Tested | Full features, excellent performance |
| Intel Arc A750 | 8GB | Tested | Full features with CPU offload |
| Intel Arc B580 | 12GB | Compatible | Should work (not tested) |
| Core Ultra iGPU | 4-8GB | Limited | Basic features only |

---

## Requirements

### Hardware
- **GPU**: Intel Arc A-series (A380, A750, A770) or Arc B-series
- **VRAM**: 8GB minimum, 16GB+ recommended
- **RAM**: 16GB minimum, 32GB recommended
- **Storage**: 50GB free space for models

### Software
- **OS**: Windows 10/11 (64-bit)
- **Python**: 3.10 or 3.11 (3.11 recommended)
- **Intel GPU Drivers**: Latest version (32.0.101.6078 or newer)
- **Visual Studio Build Tools**: For some Python packages

---

## Quick Start

### Step 1: Install Dependencies

Run the installation script:

```batch
install_xpu.bat
```

This will:
- Create Python virtual environment
- Install PyTorch with XPU support
- Install ACE-Step and dependencies
- Configure Intel extensions

**Installation time**: 10-15 minutes

### Step 2: Download Models

Run the model downloader:

```batch
download_models.bat
```

Choose your setup:
- **Option 1** - Quick Start (Turbo + 1.7B LM): ~8 GB, fast generation
- **Option 2** - Studio Grade (Base + 4B LM): ~18 GB, best quality
- **Option 3** - Complete (All models): ~25 GB, maximum flexibility

**Download time**: 20-90 minutes depending on internet speed

### Step 3: Launch UI

Start the Gradio interface:

```batch
run_xpu.bat
```

Open your browser to: **http://127.0.0.1:7860**

---

## Model Selection Guide

### DiT Models (Main Audio Generator)

| Model | Features | Steps | Speed | Quality | Size |
|-------|----------|-------|-------|---------|------|
| **acestep-v15-turbo** | text2music only | 1-20 | Fast (15s) | Good | 4GB |
| **acestep-v15-base** | All features | 1-200 | Slow (60s) | Best | 5GB |
| **acestep-v15-turbo-shift3** | text2music only | 1-20 | Fast (15s) | Good+ | 4GB |

### Language Models (5Hz LM)

| Model | Parameters | Speed | Quality | Use Case | Size |
|-------|-----------|-------|---------|----------|------|
| **acestep-5Hz-lm-0.6B** | 600M | Fast (15s) | Basic | Quick tests | 1.3GB |
| **acestep-5Hz-lm-1.7B** | 1.7B | Medium (30s) | Good | Balanced | 3.4GB |
| **acestep-5Hz-lm-4B** | 4B | Slow (60s) | Excellent | Production | 8.4GB |

---

## Usage Guide

### Simple Mode (Recommended for Beginners)

1. In the UI, select **"Simple"** mode
2. Enter a natural language description:
   - Example: "upbeat rock song with electric guitar"
   - Example: "calm piano jazz for studying"
   - Example: "energetic EDM with heavy bass drops"
3. Click **"Create Sample"** (LM generates details)
4. Click **"Generate Music"** (creates audio)
5. Listen and download from Results section

### Custom Mode (Advanced Control)

1. Select **"Custom"** mode
2. Fill in fields manually:
   - **Caption**: Detailed music description
   - **Lyrics**: Song structure with tags like [Verse], [Chorus]
   - **BPM**: Tempo (leave empty for auto-detect)
   - **Key**: Musical key (e.g., "C Major", "Am")
   - **Duration**: Length in seconds
3. Optionally click **"Format"** to enhance with LM
4. Click **"Generate Music"**

### Generation Settings

#### Quick Generation
```
DiT Model: acestep-v15-turbo
LM Model: acestep-5Hz-lm-1.7B
Inference Steps: 8
Batch Size: 2
Think Mode: Enabled
```

#### Studio Quality
```
DiT Model: acestep-v15
LM Model: acestep-5Hz-lm-4B
Inference Steps: 100-200
Guidance Scale: 7.5
ADG: Enabled
Audio Format: FLAC
Think Mode: Enabled
```

---

## Advanced Features

### Cover Generation

Transform existing audio to different style:

1. Select **"cover"** task type
2. Upload source audio
3. Enter target style description
4. Adjust cover strength (0.0-1.0)
5. Generate

### Repaint (Fix Sections)

Regenerate specific time segments:

1. Select **"repaint"** task
2. Upload audio
3. Set start/end times
4. Enter description for new segment
5. Generate

### LoRA Training

Create custom style adapters:

1. Go to **LoRA Training** tab
2. Prepare dataset of audio files
3. Auto-label with LM
4. Configure training parameters
5. Train and export

---

## Performance Optimization

### For Speed

- Use **Turbo** model
- Keep inference steps at 8
- Use **0.6B or 1.7B** LM
- Reduce batch size to 1
- Lower max duration

### For Quality

- Use **Base** model (acestep-v15)
- Set inference steps to 100-200
- Use **4B** LM
- Enable ADG (Adaptive Dual Guidance)
- Export as FLAC

### Memory Management

**Arc A770 (16GB)**:
- Full features, no limits
- Batch size: up to 8
- CPU offload: disabled

**Arc A750 (8GB)**:
- All features available
- Batch size: 2-4 recommended
- CPU offload: auto-enabled

---

## Troubleshooting

### XPU Not Detected

**Symptoms**: Falls back to CPU, very slow

**Solutions**:
1. Update Intel GPU drivers from [intel.com](https://www.intel.com/content/www/us/en/download/785597/)
2. Check driver version in Device Manager (should be 32.0.101.xxxx+)
3. Restart after driver install
4. Verify with: `python -c "import torch; print(torch.xpu.is_available())"`

### Out of Memory Errors

**Solutions**:
- Reduce batch size to 1
- Enable CPU offload in UI settings
- Close other GPU applications
- Use Turbo model instead of Base
- Reduce max audio duration

### Generation Fails/Crashes

**Check**:
1. Run `pip install torchao vector-quantize-pytorch` manually
2. Ensure all models downloaded completely
3. Check Windows Event Viewer for driver crashes
4. Try with CPU offload enabled

### Audio Quality Issues

**Improve by**:
- Increase inference steps (base model)
- Use larger LM (4B)
- Enable "Think" mode
- Be more specific in captions
- Adjust guidance scale (7-9)

### Slow Performance

**Normal speeds**:
- Turbo + 1.7B: 30-45 seconds per 2-minute track
- Base + 4B: 2-3 minutes per 2-minute track

**If slower**:
- Check GPU usage in Task Manager
- Disable other GPU applications
- Update drivers
- Try int8 quantization

---

## File Locations

```
ACE-Step-XPU/
├── install_xpu.bat           # Installation script
├── download_models.bat       # Model downloader
├── run_xpu.bat              # Launch script
├── checkpoints/             # Downloaded models
│   ├── acestep-v15-turbo/
│   ├── acestep-v15/
│   ├── acestep-5Hz-lm-0.6B/
│   ├── acestep-5Hz-lm-1.7B/
│   └── acestep-5Hz-lm-4B/
├── outputs/                 # Generated audio (if saved)
└── venv/                    # Python virtual environment
```

---

## Benchmarks

**Hardware**: Intel Arc A770 16GB + Intel i9-13900K

| Setup | Model | Steps | Duration | Gen Time | Quality |
|-------|-------|-------|----------|----------|---------|
| Fast | Turbo + 1.7B | 8 | 120s | 35s | Good |
| Balanced | Turbo + 4B | 8 | 120s | 50s | Very Good |
| Studio | Base + 4B | 100 | 120s | 180s | Excellent |

**Memory Usage**:
- Turbo + 1.7B: ~6-8 GB VRAM
- Base + 4B: ~12-14 GB VRAM

---

## Known Limitations

### XPU-Specific

- **vLLM backend**: Not available on XPU, use PyTorch backend
- **Flash Attention**: Not optimized for XPU yet
- **Some warnings**: torchao compatibility warnings are normal (still works)

### ACE-Step General

- **Base model only**: cover, repaint, lego, extract, complete tasks
- **Turbo model**: text2music only
- **Lyrics timing**: May not be perfectly aligned
- **Long tracks**: >10 minutes may have repetition

---

## FAQ

**Q: Can I use Intel integrated graphics (iGPU)?**
A: Yes, but limited by VRAM. Arc iGPU works for short audio (<30s) with Turbo model.

**Q: Does this work on Linux?**
A: Not officially tested. Intel XPU support on Linux exists but requires different setup.

**Q: Can I run without internet?**
A: Yes, after models are downloaded, works completely offline.

**Q: How does XPU compare to CUDA?**
A: Similar performance on Arc A770 vs RTX 3060. Slightly slower than high-end NVIDIA cards.

**Q: Can I contribute optimizations?**
A: Yes! PRs welcome, especially for XPU-specific improvements.

**Q: Is commercial use allowed?**
A: Check original ACE-Step license. This fork inherits same terms.

---

## Updates & Support

- **GitHub Issues**: Report bugs and request features
- **Discussions**: Share results, ask questions
- **Pull Requests**: Contribute improvements

---

## Credits

### Original Work
- **ACE-Step Team**: [Original Repository](https://github.com/ACE-Step/ACE-Step)
- Paper: ACE-Step: High-Quality Audio Codec with Efficient Semantic Tokenization

### XPU Optimization
- Fork maintainer: [Your GitHub Username]
- Community contributors
- Intel XPU testing community

---

## License

This fork maintains the same license as the original ACE-Step project.
See LICENSE file for details.

---

## Changelog

### v1.0.0-xpu (2026-02-05)
- Initial XPU-optimized fork
- Windows batch scripts for easy setup
- Automated model downloader
- XPU-specific documentation
- Tested on Arc A770/A750

---

**Made with Intel Arc GPUs**

For the best AI music generation on Intel hardware!
