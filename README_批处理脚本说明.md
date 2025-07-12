# ComfyUI-Arvin 批处理脚本说明

本项目提供了几个批处理脚本，方便在Windows系统上快速安装、更新和启动ComfyUI。

## 脚本列表

### 1. `install.bat` - 环境安装脚本
**用途：** 首次安装和配置ComfyUI环境

**功能：**
- 检查Python环境
- 创建虚拟环境（可选）
- 安装项目依赖
- 创建必要的目录结构
- 生成配置文件模板

**使用方法：**
1. 双击运行 `install.bat`
2. 按照提示选择是否创建虚拟环境
3. 等待依赖安装完成

### 2. `start.bat` - 交互式启动脚本
**用途：** 启动ComfyUI，支持自定义参数

**功能：**
- 检查环境配置
- 自动激活虚拟环境
- 询问启动参数（CPU模式、端口等）
- 启动ComfyUI服务

**使用方法：**
1. 双击运行 `start.bat`
2. 选择是否使用CPU模式
3. 输入端口号（可选，默认8188）
4. 等待服务启动

### 3. `quick_start.bat` - 快速启动脚本
**用途：** 使用默认设置快速启动ComfyUI

**功能：**
- 自动检查环境
- 使用默认配置启动
- 无需用户交互

**使用方法：**
- 直接双击运行即可

### 4. `update.bat` - 项目更新脚本
**用途：** 更新ComfyUI代码和依赖

**功能：**
- 检查Git状态
- 拉取最新代码
- 更新Python依赖

**使用方法：**
1. 双击运行 `update.bat`
2. 确认是否更新
3. 等待更新完成

### 5. `fix_install.bat` - 安装问题修复脚本
**用途：** 解决依赖安装失败的问题

**功能：**
- 诊断安装问题
- 清理pip缓存
- 尝试多种安装方法
- 使用国内镜像源
- 提供详细的故障排除建议

**使用方法：**
1. 当 `install.bat` 失败时运行
2. 按照提示进行诊断
3. 自动尝试多种解决方案

### 6. `修复PyTorch.bat` - PyTorch CUDA修复脚本
**用途：** 修复PyTorch CUDA支持问题

**功能：**
- 检测当前PyTorch版本
- 自动卸载不支持的版本
- 检测CUDA版本并安装对应PyTorch
- 支持多种安装源
- 自动创建CPU启动脚本（如需要）

**使用方法：**
1. 当遇到"Torch not compiled with CUDA enabled"错误时运行
2. 按照提示进行修复
3. 验证安装结果

### 7. `start_cpu.bat` - CPU模式启动脚本
**用途：** 使用CPU模式启动ComfyUI

**功能：**
- 专门用于CPU模式启动
- 自动激活虚拟环境
- 检查PyTorch安装
- 使用--cpu参数启动

**使用方法：**
- 直接双击运行即可（CPU模式）

## 使用流程

### 首次使用
1. 运行 `install.bat` 安装环境
2. 将模型文件放入相应目录
3. 运行 `start.bat` 或 `quick_start.bat` 启动服务

### 日常使用
- 直接运行 `quick_start.bat` 快速启动
- 或运行 `start.bat` 自定义启动参数

### 更新项目
- 运行 `update.bat` 获取最新更新

## 目录结构

安装完成后，会自动创建以下目录：

```
ComfyUI-Arvin/
├── models/
│   ├── checkpoints/    # 检查点模型
│   ├── vae/           # VAE模型
│   ├── lora/          # LoRA模型
│   ├── controlnet/    # ControlNet模型
│   └── upscale_models/ # 超分辨率模型
├── input/             # 输入文件
├── output/            # 输出文件
└── venv/              # 虚拟环境（如果创建）
```

## 注意事项

1. **Python版本要求：** Python 3.10或更高版本
2. **虚拟环境：** 推荐使用虚拟环境避免依赖冲突
3. **模型文件：** 需要手动下载并放入相应目录
4. **网络连接：** 首次安装需要网络连接下载依赖
5. **GPU支持：** 默认使用GPU，可选择CPU模式

## 故障排除

### 常见问题

1. **Python未找到**
   - 确保已安装Python并添加到PATH
   - 下载地址：https://www.python.org/downloads/

2. **依赖安装失败**
   - 运行 `fix_install.bat` 自动修复
   - 检查网络连接
   - 尝试使用国内镜像源
   - 关闭杀毒软件或防火墙
   - 以管理员身份运行脚本
   - 手动运行：`pip install -r requirements.txt --user`

3. **启动失败**
   - 检查是否在正确的目录运行脚本
   - 确认依赖已正确安装
   - 查看错误信息进行针对性解决

4. **模型加载失败**
   - 确认模型文件已放入正确目录
   - 检查模型文件是否完整
   - 查看ComfyUI日志获取详细错误信息

5. **PyTorch CUDA错误**
   - 运行 `修复PyTorch.bat` 自动修复
   - 检查NVIDIA驱动是否最新
   - 确认GPU支持CUDA
   - 使用 `start_cpu.bat` 以CPU模式运行

## 技术支持

如果遇到问题，请：
1. 查看ComfyUI官方文档
2. 检查项目GitHub页面
3. 查看控制台错误信息 