@echo off
chcp 65001 >nul
echo ========================================
echo     腾讯云一键部署脚本
echo ========================================
echo.

:: 检查 Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 请先安装 Node.js
    pause
    exit /b 1
)

:: 检查 npm
npm --version >nul 2>&1
if errorlevel 1 (
    echo ❌ npm 未找到
    pause
    exit /b 1
)

echo 🔍 检查环境变量...
if "%TENCENT_SECRET_ID%"=="" (
    echo ❌ 请设置环境变量 TENCENT_SECRET_ID
    echo 示例: set TENCENT_SECRET_ID=your-secret-id
    pause
    exit /b 1
)

if "%TENCENT_SECRET_KEY%"=="" (
    echo ❌ 请设置环境变量 TENCENT_SECRET_KEY
    echo 示例: set TENCENT_SECRET_KEY=your-secret-key
    pause
    exit /b 1
)

if "%COS_BUCKET%"=="" (
    echo ⚠️  未设置 COS_BUCKET，使用默认值
    set COS_BUCKET=quantum-trading-1234567890
)

echo ✅ 环境检查完成
echo.

echo 📦 安装部署依赖...
npm install cos-nodejs-sdk-v5 --save-dev
if errorlevel 1 (
    echo ❌ 依赖安装失败
    pause
    exit /b 1
)

echo.
echo 🚀 开始部署...
node deploy-to-cos.js
if errorlevel 1 (
    echo ❌ 部署失败
    pause
    exit /b 1
)

echo.
echo 🎉 部署完成！
echo 🔗 访问地址: https://%COS_BUCKET%.cos-website.ap-guangzhou.myqcloud.com
echo.
echo 💡 提示：
echo    - 如需自定义域名，请在腾讯云控制台配置
echo    - 建议开启 CDN 加速访问速度
echo    - 首次访问可能需要等待几分钟生效
echo.
pause