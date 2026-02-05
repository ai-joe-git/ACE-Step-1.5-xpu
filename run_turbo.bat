@echo off
cd /d "%~dp0"

echo ========================================
echo ACE-Step TURBO Mode (Quick Generation)
echo ========================================

call venv\Scripts\activate.bat

set SYCL_CACHE_PERSISTENT=1
set SYCL_PI_LEVEL_ZERO_USE_IMMEDIATE_COMMANDLISTS=1
set PYTORCH_DEVICE=xpu

pip install -q vector-quantize-pytorch torchao 2>nul

echo.
echo Starting with:
echo - Model: acestep-v15-turbo
echo - LM: acestep-5Hz-lm-1.7B
echo - Server: http://127.0.0.1:7860
echo.

python acestep\acestep_v15_pipeline.py --port 7860 --config_path acestep-v15-turbo --lm_model_path acestep-5Hz-lm-1.7B --init_service true

pause
