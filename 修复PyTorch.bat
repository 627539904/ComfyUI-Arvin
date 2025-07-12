@echo off
chcp 65001 >nul
echo ========================================
echo 修复PyTorch CUDA支持问题
echo ========================================
echo.

:: 检查是否在正确的目录
if not exist "main.py" (
    echo 错误：请在ComfyUI-Arvin项目根目录下运行此脚本
    echo 当前目录：%CD%
    pause
    exit /b 1
)

:: 激活虚拟环境（如果存在）
if exist "venv\Scripts\activate.bat" (
    echo 激活虚拟环境...
    call venv\Scripts\activate.bat
    echo 虚拟环境已激活
    echo.
)

echo 当前PyTorch版本信息：
python -c "import torch; print('PyTorch版本:', torch.__version__); print('CUDA可用:', torch.cuda.is_available()); print('CUDA版本:', torch.version.cuda if torch.cuda.is_available() else 'N/A')"

:: 检查当前PyTorch是否已支持CUDA
python -c "import torch; print(torch.cuda.is_available())" > tmp_cuda_check.txt
set /p CUDA_OK=<tmp_cuda_check.txt
if exist tmp_cuda_check.txt del tmp_cuda_check.txt

echo.
if "%CUDA_OK%"=="True" (
    echo 当前PyTorch已支持CUDA，无需修复！
    pause
    exit /b 0
)

echo 检测到PyTorch没有CUDA支持，准备修复...
echo.

echo 是否确定要卸载当前PyTorch并重新安装？(Y/N)
set /p confirm=
if /i not "%confirm%"=="Y" (
    echo 已取消卸载和修复操作。
    pause
    exit /b 0
)

echo 1. 卸载当前PyTorch...
pip uninstall torch torchvision torchaudio -y
echo.

echo 2. 安装支持CUDA 11.8的PyTorch...
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 --timeout 600 --retries 5

if %errorlevel% neq 0 (
    echo 官方源安装失败，尝试使用国内镜像...
    pip install torch torchvision torchaudio -i https://pypi.tuna.tsinghua.edu.cn/simple/ --timeout 600 --retries 5
    if %errorlevel% neq 0 (
        echo 镜像源安装失败，尝试CPU版本...
        echo 注意：CPU版本运行速度较慢
        pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu --timeout 600 --retries 5
        if %errorlevel% neq 0 (
            echo 所有安装方法都失败了
            echo 请手动安装PyTorch：
            echo 1. 访问 https://pytorch.org/get-started/locally/
            echo 2. 选择适合您系统的版本
            echo 3. 运行生成的安装命令
            pause
            exit /b 1
        ) else (
            echo CPU版本PyTorch安装成功
            set USE_CPU=1
        )
    ) else (
        echo PyTorch安装成功（镜像源）
    )
) else (
    echo PyTorch安装成功（官方源）
)
echo.

echo 3. 验证PyTorch安装...
python -c "import torch; print('PyTorch版本:', torch.__version__); print('CUDA可用:', torch.cuda.is_available()); print('CUDA版本:', torch.version.cuda if torch.cuda.is_available() else 'N/A'); print('GPU数量:', torch.cuda.device_count() if torch.cuda.is_available() else 0)"

if %errorlevel% neq 0 (
    echo PyTorch验证失败
    pause
    exit /b 1
)
echo.

:: 如果使用CPU版本，创建启动脚本
if "%USE_CPU%"=="1" (
    echo 检测到使用CPU版本，创建CPU启动脚本...
    echo @echo off > start_cpu.bat
    echo chcp 65001 ^>nul >> start_cpu.bat
    echo echo 使用CPU模式启动ComfyUI... >> start_cpu.bat
    echo if exist "venv\Scripts\activate.bat" call venv\Scripts\activate.bat >> start_cpu.bat
    echo python main.py --cpu >> start_cpu.bat
    echo pause >> start_cpu.bat
    echo CPU启动脚本已创建：start_cpu.bat
    echo.
)

echo ========================================
echo PyTorch修复完成！
echo ========================================
echo.
if "%USE_CPU%"=="1" (
    echo 注意：当前使用CPU版本PyTorch
    echo 建议使用 start_cpu.bat 启动ComfyUI
    echo 或使用 start.bat 并选择CPU模式
) else (
    echo PyTorch已支持CUDA 11.8
    echo 现在可以使用 start.bat 正常启动ComfyUI
)
echo.
pause 