@echo off
chcp 65001 >nul
color 0B
echo ========================================
echo        🚀 量子交易系统 🚀
echo          快速部署工具
echo ========================================
echo.

:: 自动检测最佳部署方式
echo 🔍 正在检测部署环境...
echo.

:: 检查基础环境
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js 未安装，请先安装 Node.js
    echo 📥 下载地址：https://nodejs.org/
    pause
    exit /b 1
)
echo ✅ Node.js 环境正常

npm --version >nul 2>&1
if errorlevel 1 (
    echo ❌ npm 未找到
    pause
    exit /b 1
)
echo ✅ npm 环境正常

:: 检查腾讯云配置
set TENCENT_AVAILABLE=0
if not "%TENCENT_SECRET_ID%"=="" (
    if not "%TENCENT_SECRET_KEY%"=="" (
        set TENCENT_AVAILABLE=1
        echo ✅ 腾讯云配置已设置
    )
)

if %TENCENT_AVAILABLE%==0 (
    echo ⚠️  腾讯云配置未设置
)

:: 检查 Git 配置
set GIT_AVAILABLE=0
git --version >nul 2>&1
if not errorlevel 1 (
    git remote -v >nul 2>&1
    if not errorlevel 1 (
        set GIT_AVAILABLE=1
        echo ✅ Git 仓库已配置
    )
)

if %GIT_AVAILABLE%==0 (
    echo ⚠️  Git 仓库未配置
)

echo.
echo ========================================
echo          推荐部署方案
echo ========================================
echo.

:: 推荐最佳方案（优先免费方案）
if %GIT_AVAILABLE%==1 (
    echo 🌟 推荐：GitHub Pages 部署（🆓 完全免费 + 自动化）
    echo    ✅ 无需任何费用，包括域名和CDN
    echo    ✅ 自动部署，代码推送后自动发布
    echo    ✅ 企业级稳定性，支持HTTPS和自定义域名
    echo.
    set /p confirm=是否使用 GitHub Pages 免费部署？(Y/n): 
    if /i "%confirm%"=="" set confirm=Y
    if /i "%confirm%"=="Y" goto DEPLOY_GITHUB
    if /i "%confirm%"=="y" goto DEPLOY_GITHUB
)

if %TENCENT_AVAILABLE%==1 (
    echo 🌟 备选：腾讯云 COS 部署（💰 按量付费，国内访问快）
    echo.
    set /p confirm=是否使用腾讯云部署？(Y/n): 
    if /i "%confirm%"=="" set confirm=Y
    if /i "%confirm%"=="Y" goto DEPLOY_TENCENT
    if /i "%confirm%"=="y" goto DEPLOY_TENCENT
)

echo 🌟 推荐：Netlify 部署（⚡ 超快 + 免费）
echo    ✅ 全球300+节点，边缘计算加速
echo    ✅ 100GB免费流量，自动优化
echo    ✅ 拖拽部署，无需技术基础
echo.
set /p confirm=是否使用 Netlify 部署？(Y/n): 
if /i "%confirm%"=="" set confirm=Y
if /i "%confirm%"=="Y" goto DEPLOY_NETLIFY
if /i "%confirm%"=="y" goto DEPLOY_NETLIFY

echo 🌟 备选：本地预览（快速测试）
echo.
set /p confirm=是否启动本地预览？(Y/n): 
if /i "%confirm%"=="" set confirm=Y
if /i "%confirm%"=="Y" goto DEPLOY_LOCAL
if /i "%confirm%"=="y" goto DEPLOY_LOCAL

echo 取消部署
pause
exit /b 0

:DEPLOY_NETLIFY
echo.
echo ========================================
echo       ⚡ Netlify 快速部署
echo ========================================
echo.

echo 🚀 启动 Netlify 部署工具...
call "Netlify部署.bat"
if errorlevel 1 (
    echo ❌ Netlify 部署失败
    echo 💡 请检查网络连接或重试
    pause
    exit /b 1
)

echo.
echo 🎉 Netlify 部署完成！
echo 🔗 您的网站已部署到 Netlify 全球 CDN
echo 📊 可在 Netlify 控制台查看详细信息
echo.
pause
exit /b 0

:DEPLOY_TENCENT
echo.
echo ========================================
echo       🚀 腾讯云快速部署
echo ========================================
echo.

echo 📦 准备部署环境...
npm install --silent
if errorlevel 1 (
    echo ❌ 依赖安装失败
    pause
    exit /b 1
)

echo 🔨 构建项目...
npm run build --silent
if errorlevel 1 (
    echo ❌ 项目构建失败
    pause
    exit /b 1
)

echo 📤 上传到腾讯云...
npm run deploy:tencent
if errorlevel 1 (
    echo ❌ 腾讯云部署失败
    echo 💡 请检查腾讯云配置和网络连接
    pause
    exit /b 1
)

echo.
echo 🎉 腾讯云部署成功！
echo 🔗 访问地址：https://%COS_BUCKET%.cos-website.ap-guangzhou.myqcloud.com
echo.
echo 💡 提示：
echo    - 首次部署可能需要等待 2-5 分钟生效
echo    - 建议配置自定义域名以获得更好的访问体验
echo    - 可在腾讯云控制台查看详细信息
echo.
pause
exit /b 0

:DEPLOY_GITHUB
echo.
echo ========================================
echo      🚀 GitHub Pages 快速部署
echo ========================================
echo.

echo 📦 准备部署环境...
npm install --silent
if errorlevel 1 (
    echo ❌ 依赖安装失败
    pause
    exit /b 1
)

echo 🔨 构建项目...
npm run build --silent
if errorlevel 1 (
    echo ❌ 项目构建失败
    pause
    exit /b 1
)

echo 📤 推送到 GitHub...
git add .
git commit -m "Auto deploy: %date% %time%"
git push

echo 🚀 触发 GitHub Actions 部署...
echo.
echo 🎉 GitHub Pages 部署已启动！
echo 🔗 查看部署状态：https://github.com/your-username/your-repo/actions
echo 📱 访问地址：https://your-username.github.io/your-repo
echo.
echo 💡 提示：
echo    - GitHub Actions 部署通常需要 2-5 分钟
echo    - 可在 GitHub 仓库的 Actions 页面查看部署进度
echo    - 部署完成后会自动更新网站内容
echo.
pause
exit /b 0

:DEPLOY_LOCAL
echo.
echo ========================================
echo        🚀 本地预览部署
echo ========================================
echo.

echo 📦 准备开发环境...
npm install --silent
if errorlevel 1 (
    echo ❌ 依赖安装失败
    pause
    exit /b 1
)

echo 🌐 启动开发服务器...
echo.
echo 🎉 本地服务器启动成功！
echo 📱 本地访问：http://localhost:3000
echo 🌍 外网访问：https://ai-quantum-trading.loca.lt
echo.
echo ⚠️  按 Ctrl+C 停止服务器
echo 💡 修改代码后会自动刷新页面
echo.
npm run dev

pause
exit /b 0