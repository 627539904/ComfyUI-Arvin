@echo off
chcp 65001 >nul
echo ========================================
echo ComfyUI-Arvin CPU模式启动
echo ========================================
echo.

:: 检查是否在正确的目录
if not exist "main.py" (
    echo 错误：请在ComfyUI-Arvin项目根目录下运行此脚本
    echo 当前目录：%CD%
    pause
    exit /b 1
)

:: 检查Python是否安装
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误：未找到Python，请先安装Python 3.10或更高版本
    echo 下载地址：https://www.python.org/downloads/
    pause
    exit /b 1
)

echo 正在检查Python版本...
python --version
echo.

:: 激活虚拟环境（如果存在）
if exist "venv\Scripts\activate.bat" (
    echo 激活虚拟环境...
    call venv\Scripts\activate.bat
    echo 虚拟环境已激活
    echo.
)

:: 检查PyTorch
echo 检查PyTorch安装...
python -c "import torch; print('PyTorch版本:', torch.__version__); print('CUDA可用:', torch.cuda.is_available())" >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误：PyTorch未安装，请先运行 install.bat
    pause
    exit /b 1
)

echo 警告：CPU模式运行速度较慢，请耐心等待
echo.
echo 正在启动ComfyUI（CPU模式）...
echo 启动后请在浏览器中访问：http://localhost:8188
echo 按Ctrl+C可以停止服务
echo.

:: 启动ComfyUI（CPU模式）
python main.py --cpu

echo.
echo ComfyUI已停止运行
pause 