@echo off
chcp 65001 >nul
echo ========================================
echo ComfyUI-Arvin 启动脚本
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

:: 检查虚拟环境
if exist "venv\Scripts\activate.bat" (
    echo 检测到虚拟环境，正在激活...
    call venv\Scripts\activate.bat
    echo 虚拟环境已激活
    echo.
)

:: 检查依赖是否安装
echo 正在检查依赖...
python -c "import torch, torchvision, torchaudio" >nul 2>&1
if %errorlevel% neq 0 (
    echo 警告：PyTorch未安装，正在安装依赖...
    pip install -r requirements.txt
    if %errorlevel% neq 0 (
        echo 错误：依赖安装失败
        pause
        exit /b 1
    )
    echo 依赖安装完成
    echo.
)

:: 启动参数设置
set STARTUP_ARGS=

:: 询问是否使用CPU模式
echo 是否使用CPU模式运行？(Y/N，默认N)
set /p cpu_choice=
if /i "%cpu_choice%"=="Y" (
    set STARTUP_ARGS=--cpu
    echo 将使用CPU模式启动
)

:: 询问端口设置
echo 请输入端口号(默认8188)：
set /p port_input=
if not "%port_input%"=="" (
    set STARTUP_ARGS=%STARTUP_ARGS% --port %port_input%
    echo 将使用端口：%port_input%
) else (
    echo 将使用默认端口：8188
)

echo.
echo 正在启动ComfyUI...
echo 启动参数：%STARTUP_ARGS%
echo.
echo 启动后请在浏览器中访问：http://localhost:8188
echo 按Ctrl+C可以停止服务
echo.

:: 启动ComfyUI
python main.py %STARTUP_ARGS%

echo.
echo ComfyUI已停止运行
pause 