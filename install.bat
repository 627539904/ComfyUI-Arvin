@echo off
chcp 65001 >nul
echo ========================================
echo ComfyUI-Arvin 环境安装脚本
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

:: 询问是否创建虚拟环境
echo 是否创建虚拟环境？(推荐，Y/N)
set /p venv_choice=
if /i "%venv_choice%"=="Y" (
    echo.
    echo 正在创建虚拟环境...
    python -m venv venv
    
    if %errorlevel% equ 0 (
        echo 虚拟环境创建成功！
        echo 正在激活虚拟环境...
        call venv\Scripts\activate.bat
        echo 虚拟环境已激活
        echo.
    ) else (
        echo 虚拟环境创建失败
        pause
        exit /b 1
    )
)

:: 升级pip
echo 正在升级pip...
python -m pip install --upgrade pip
echo.

:: 安装依赖
echo 正在安装项目依赖...
echo 这可能需要几分钟时间，请耐心等待...
echo.

:: 清理临时文件
echo 清理临时文件...
pip cache purge >nul 2>&1

:: 尝试使用国内镜像源安装
echo 尝试使用国内镜像源安装依赖...
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/ --timeout 300 --retries 3

if %errorlevel% equ 0 (
    echo.
    echo 依赖安装成功！
) else (
    echo.
    echo 使用国内镜像源安装失败，尝试使用官方源...
    pip install -r requirements.txt --timeout 300 --retries 3
    
    if %errorlevel% equ 0 (
        echo.
        echo 依赖安装成功！
    ) else (
        echo.
        echo 警告：依赖安装失败，尝试使用用户模式安装...
        pip install -r requirements.txt --user --timeout 300 --retries 3
        
        if %errorlevel% equ 0 (
            echo.
            echo 依赖安装成功！（用户模式）
        ) else (
            echo.
            echo 错误：依赖安装失败
            echo 可能的解决方案：
            echo 1. 检查网络连接
            echo 2. 关闭杀毒软件或防火墙
            echo 3. 以管理员身份运行此脚本
            echo 4. 手动运行：pip install -r requirements.txt --user
            pause
            exit /b 1
        )
    )
)

:: 创建必要的目录
echo.
echo 正在创建必要的目录...
if not exist "models\checkpoints" mkdir "models\checkpoints"
if not exist "models\vae" mkdir "models\vae"
if not exist "models\lora" mkdir "models\lora"
if not exist "models\controlnet" mkdir "models\controlnet"
if not exist "models\upscale_models" mkdir "models\upscale_models"
if not exist "input" mkdir "input"
if not exist "output" mkdir "output"
echo 目录创建完成

:: 检查配置文件
if not exist "extra_model_paths.yaml" (
    echo.
    echo 正在创建配置文件模板...
    copy "extra_model_paths.yaml.example" "extra_model_paths.yaml" >nul 2>&1
    if %errorlevel% equ 0 (
        echo 配置文件模板已创建：extra_model_paths.yaml
        echo 您可以根据需要编辑此文件来配置模型路径
    )
)

echo.
echo ========================================
echo 安装完成！
echo ========================================
echo.
echo 下一步：
echo 1. 将您的模型文件放入相应目录：
echo    - 检查点模型：models\checkpoints\
echo    - VAE模型：models\vae\
echo    - LoRA模型：models\lora\
echo    - ControlNet模型：models\controlnet\
echo    - 超分辨率模型：models\upscale_models\
echo.
echo 2. 运行 start.bat 启动ComfyUI
echo.
echo 3. 在浏览器中访问：http://localhost:8188
echo.
echo 按任意键退出...
pause >nul 