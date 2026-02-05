@echo off
echo ========================================
echo ACE-Step for Intel XPU - Installation
echo ========================================
echo.

:: Check Python version
python --version 2>nul
if errorlevel 1 (
    echo ERROR: Python not found! Please install Python 3.10 or 3.11
    echo Download from: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo Creating virtual environment...
python -m venv venv
call venv\Scripts\activate.bat

echo.
echo Upgrading pip...
python.exe -m pip install --upgrade pip

echo.
echo Installing Intel PyTorch XPU (nightly build)...
pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/xpu

echo.
echo Installing Intel Extension for PyTorch...
pip install intel-extension-for-pytorch

echo.
echo Installing ACE-Step and dependencies...
pip install -e .

echo.
echo Installing additional packages...
pip install accelerate diffusers gradio soundfile librosa scipy
pip install vector-quantize-pytorch torchao

echo.
echo ========================================
set /p training="Install training dependencies (lightning, peft)? (y/n): "
if /i "%training%"=="y" (
    echo Installing training packages...
    pip install lightning peft
)

echo.
echo ========================================
echo Installation Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Run download_models.bat to download AI models
echo 2. Run run_xpu.bat to start the UI
echo.
pause
