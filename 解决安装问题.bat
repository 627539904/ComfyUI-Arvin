@echo off
chcp 65001 >nul
echo ========================================
echo 解决 comfyui_frontend_package 安装问题
echo ========================================
echo.

echo 您遇到的问题是：
echo 1. 网络连接超时
echo 2. 文件被占用无法访问
echo.
echo 正在应用解决方案...
echo.

:: 清理临时文件
echo 1. 清理临时文件和缓存...
taskkill /f /im python.exe >nul 2>&1
taskkill /f /im pip.exe >nul 2>&1
pip cache purge >nul 2>&1

:: 删除可能被占用的临时文件
if exist "%TEMP%\pip-unpack-*" (
    echo 删除临时解压文件...
    rmdir /s /q "%TEMP%\pip-unpack-*" >nul 2>&1
)

echo 清理完成
echo.

:: 尝试安装 comfyui_frontend_package
echo 2. 尝试安装 comfyui_frontend_package...
echo 使用清华大学镜像源，增加超时时间...

pip install comfyui-frontend-package==1.12.14 -i https://pypi.tuna.tsinghua.edu.cn/simple/ --timeout 600 --retries 5 --no-cache-dir

if %errorlevel% equ 0 (
    echo.
    echo comfyui_frontend_package 安装成功！
    echo.
    echo 现在尝试安装其他依赖...
    pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/ --timeout 600 --retries 5 --no-cache-dir
    
    if %errorlevel% equ 0 (
        echo.
        echo 所有依赖安装成功！
        goto :success
    ) else (
        echo.
        echo 其他依赖安装失败，尝试用户模式...
        pip install -r requirements.txt --user -i https://pypi.tuna.tsinghua.edu.cn/simple/ --timeout 600 --retries 5 --no-cache-dir
        if %errorlevel% equ 0 goto :success
    )
) else (
    echo.
    echo 使用镜像源安装失败，尝试官方源...
    pip install comfyui-frontend-package==1.12.14 --timeout 600 --retries 5 --no-cache-dir --user
    
    if %errorlevel% equ 0 (
        echo.
        echo comfyui_frontend_package 安装成功！（用户模式）
        echo.
        echo 现在尝试安装其他依赖...
        pip install -r requirements.txt --user --timeout 600 --retries 5 --no-cache-dir
        if %errorlevel% equ 0 goto :success
    )
)

:: 如果还是失败，提供手动解决方案
echo.
echo ========================================
echo 自动安装失败，请尝试手动解决方案
echo ========================================
echo.
echo 解决方案1：手动下载安装
echo 1. 访问：https://pypi.tuna.tsinghua.edu.cn/simple/comfyui-frontend-package/
echo 2. 下载 comfyui_frontend_package-1.12.14-py3-none-any.whl
echo 3. 运行：pip install 下载的文件路径
echo.
echo 解决方案2：使用conda
echo 1. 安装Anaconda或Miniconda
echo 2. 创建新环境：conda create -n comfyui python=3.10
echo 3. 激活环境：conda activate comfyui
echo 4. 安装依赖：pip install -r requirements.txt
echo.
echo 解决方案3：跳过前端包
echo 1. 编辑 requirements.txt
echo 2. 注释掉 comfyui-frontend-package 这一行
echo 3. 重新运行 install.bat
echo.
echo 按任意键退出...
pause >nul
exit /b 1

:success
echo.
echo ========================================
echo 问题解决成功！
echo ========================================
echo.
echo 现在可以运行 start.bat 启动ComfyUI了
echo.
pause 