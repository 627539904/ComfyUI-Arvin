@echo off
chcp 65001 >nul
echo ========================================
echo ComfyUI-Arvin 安装问题修复脚本
echo ========================================
echo.

:: 检查是否在正确的目录
if not exist "main.py" (
    echo 错误：请在ComfyUI-Arvin项目根目录下运行此脚本
    echo 当前目录：%CD%
    pause
    exit /b 1
)

echo 正在诊断安装问题...
echo.

:: 检查Python版本
echo 1. 检查Python版本...
python --version
if %errorlevel% neq 0 (
    echo 错误：Python未安装或未添加到PATH
    pause
    exit /b 1
)
echo.

:: 清理pip缓存
echo 2. 清理pip缓存...
pip cache purge
echo 缓存清理完成
echo.

:: 升级pip
echo 3. 升级pip...
python -m pip install --upgrade pip
echo.

:: 检查网络连接
echo 4. 检查网络连接...
ping -n 1 pypi.org >nul 2>&1
if %errorlevel% neq 0 (
    echo 警告：无法连接到PyPI官方源，将使用国内镜像
    set USE_MIRROR=1
) else (
    echo 网络连接正常
    set USE_MIRROR=0
)
echo.

:: 尝试不同的安装方法
echo 5. 尝试安装依赖...

:: 方法1：使用国内镜像源
if "%USE_MIRROR%"=="1" (
    echo 使用清华大学镜像源...
    pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/ --timeout 600 --retries 5
    if %errorlevel% equ 0 goto :success
)

:: 方法2：使用阿里云镜像源
echo 使用阿里云镜像源...
pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/ --timeout 600 --retries 5
if %errorlevel% equ 0 goto :success

:: 方法3：使用官方源
echo 使用官方PyPI源...
pip install -r requirements.txt --timeout 600 --retries 5
if %errorlevel% equ 0 goto :success

:: 方法4：用户模式安装
echo 尝试用户模式安装...
pip install -r requirements.txt --user --timeout 600 --retries 5
if %errorlevel% equ 0 goto :success

:: 方法5：逐个安装关键依赖
echo 尝试逐个安装关键依赖...
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 --timeout 600 --retries 5
if %errorlevel% equ 0 (
    echo PyTorch安装成功，继续安装其他依赖...
    pip install numpy einops transformers tokenizers sentencepiece safetensors aiohttp yarl pyyaml Pillow scipy tqdm psutil --timeout 600 --retries 5
    if %errorlevel% equ 0 goto :success
)

:: 所有方法都失败
echo.
echo ========================================
echo 所有安装方法都失败了
echo ========================================
echo.
echo 可能的解决方案：
echo.
echo 1. 网络问题：
echo    - 检查网络连接
echo    - 尝试使用VPN或代理
echo    - 更换网络环境
echo.
echo 2. 权限问题：
echo    - 以管理员身份运行此脚本
echo    - 关闭杀毒软件或防火墙
echo    - 检查文件夹权限
echo.
echo 3. 手动安装：
echo    - 手动下载whl文件安装
echo    - 使用conda环境
echo    - 使用Docker
echo.
echo 4. 特定包问题：
echo    - 尝试安装预编译的PyTorch版本
echo    - 检查Python版本兼容性
echo.
echo 按任意键退出...
pause >nul
exit /b 1

:success
echo.
echo ========================================
echo 依赖安装成功！
echo ========================================
echo.
echo 现在可以运行 start.bat 启动ComfyUI了
echo.
pause 