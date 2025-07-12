@echo off
chcp 65001 >nul
echo ========================================
echo ComfyUI-Arvin 项目更新脚本
echo ========================================
echo.

:: 检查是否在正确的目录
if not exist "main.py" (
    echo 错误：请在ComfyUI-Arvin项目根目录下运行此脚本
    echo 当前目录：%CD%
    pause
    exit /b 1
)

echo 正在检查Git状态...
git status
echo.

echo 是否要更新项目？(Y/N)
set /p choice=
if /i "%choice%"=="Y" (
    echo.
    echo 正在拉取最新更新...
    git pull origin main
    
    if %errorlevel% equ 0 (
        echo.
        echo 更新成功！
        echo.
        echo 正在更新Python依赖...
        pip install -r requirements.txt --upgrade
        
        if %errorlevel% equ 0 (
            echo.
            echo 依赖更新完成！
        ) else (
            echo.
            echo 警告：依赖更新失败，请手动检查
        )
    ) else (
        echo.
        echo 更新失败，请检查网络连接或Git配置
    )
) else (
    echo 取消更新
)

echo.
echo 按任意键退出...
pause >nul 