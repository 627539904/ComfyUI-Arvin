@echo off
chcp 65001 >nul
echo ========================================
echo ComfyUI-Arvin 快速启动
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
    pause
    exit /b 1
)

:: 激活虚拟环境（如果存在）
if exist "venv\Scripts\activate.bat" (
    call venv\Scripts\activate.bat
)

:: 检查依赖
python -c "import torch" >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误：PyTorch未安装，请先运行 install.bat
    pause
    exit /b 1
)

echo 正在启动ComfyUI...
echo 启动后请在浏览器中访问：http://localhost:8188
echo 按Ctrl+C可以停止服务
echo.

:: 启动ComfyUI（使用默认设置）
python main.py

echo.
echo ComfyUI已停止运行
pause 