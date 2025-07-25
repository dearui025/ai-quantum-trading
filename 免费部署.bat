@echo off
chcp 65001 >nul
color 0A
echo ========================================
echo        🆓 量子交易系统 🆓
echo         免费一键部署工具
echo      (GitHub Pages - 完全免费)
echo ========================================
echo.
echo 🎉 欢迎使用免费部署方案！
echo.
echo ✨ GitHub Pages 优势：
echo    🆓 完全免费 - 无需任何费用
echo    🚀 自动部署 - 代码推送后自动发布
echo    🔒 HTTPS 支持 - 自动提供 SSL 证书
echo    🌍 全球 CDN - GitHub 提供的企业级服务
echo    📱 自定义域名 - 支持绑定自己的域名
echo    ♾️  无流量限制 - 适合各种规模的项目
echo.
echo ========================================
echo          环境检查
echo ========================================
echo.

:: 检查 Node.js
echo 🔍 检查 Node.js...
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js 未安装
    echo.
    echo 📥 请先安装 Node.js (免费):
    echo    下载地址：https://nodejs.org/
    echo    建议版本：v18+ LTS (长期支持版)
    echo.
    pause
    exit /b 1
)
for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
echo ✅ Node.js %NODE_VERSION% 已安装

:: 检查 npm
echo 🔍 检查 npm...
npm --version >nul 2>&1
if errorlevel 1 (
    echo ❌ npm 未找到
    pause
    exit /b 1
)
for /f "tokens=*" %%i in ('npm --version') do set NPM_VERSION=%%i
echo ✅ npm %NPM_VERSION% 已安装

:: 检查 Git
echo 🔍 检查 Git...
git --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Git 未安装
    echo.
    echo 📥 请先安装 Git (免费):
    echo    下载地址：https://git-scm.com/
    echo    Git 是免费的版本控制工具，GitHub Pages 部署必需
    echo.
    pause
    exit /b 1
)
for /f "tokens=*" %%i in ('git --version') do set GIT_VERSION=%%i
echo ✅ %GIT_VERSION% 已安装

:: 检查 Git 仓库
echo 🔍 检查 Git 仓库配置...
git remote -v >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Git 仓库未配置
    echo.
    echo 📋 GitHub Pages 部署需要 Git 仓库，请选择：
    echo.
    echo [1] 🆕 创建新的 GitHub 仓库 (推荐)
    echo [2] 🔗 连接现有 GitHub 仓库
    echo [3] 📖 查看详细配置教程
    echo [0] ❌ 退出
    echo.
    set /p git_choice=请选择 (0-3): 
    
    if "%git_choice%"=="1" goto SETUP_NEW_REPO
    if "%git_choice%"=="2" goto SETUP_EXISTING_REPO
    if "%git_choice%"=="3" goto SHOW_TUTORIAL
    if "%git_choice%"=="0" exit /b 0
    echo 无效选项
    pause
    exit /b 1
)
echo ✅ Git 仓库已配置

echo.
echo ========================================
echo        🚀 开始免费部署
echo ========================================
echo.

echo 📦 安装项目依赖 (免费)...
npm install --silent
if errorlevel 1 (
    echo ❌ 依赖安装失败
    echo 💡 请检查网络连接或尝试使用国内镜像：
    echo    npm config set registry https://registry.npmmirror.com/
    pause
    exit /b 1
)
echo ✅ 依赖安装完成

echo 🔨 构建项目...
npm run build --silent
if errorlevel 1 (
    echo ❌ 项目构建失败
    echo 💡 请检查代码是否有语法错误
    pause
    exit /b 1
)
echo ✅ 项目构建完成

echo 📤 推送到 GitHub (免费托管)...
git add .
git commit -m "Deploy: %date% %time%" >nul 2>&1
git push
if errorlevel 1 (
    echo ❌ 推送失败
    echo 💡 可能的原因：
    echo    - 网络连接问题
    echo    - GitHub 认证问题
    echo    - 仓库权限问题
    pause
    exit /b 1
)
echo ✅ 代码推送成功

echo 🚀 触发 GitHub Actions 自动部署...
echo.
echo ========================================
echo        🎉 部署成功！
echo ========================================
echo.
echo ✅ 免费部署已启动！
echo.
echo 📱 访问地址：
echo    https://your-username.github.io/your-repo-name
echo.
echo 🔗 管理地址：
echo    仓库：https://github.com/your-username/your-repo-name
echo    部署状态：https://github.com/your-username/your-repo-name/actions
echo.
echo 💡 部署说明：
echo    ⏱️  GitHub Actions 通常需要 2-5 分钟完成部署
echo    🔄 每次推送代码都会自动重新部署
echo    🌍 全球访问，自动 HTTPS，完全免费
echo    📊 可在 GitHub Actions 页面查看部署进度
echo.
echo 🎊 恭喜！您的量子交易系统已成功部署到免费的 GitHub Pages！
echo.
pause
exit /b 0

:SETUP_NEW_REPO
echo.
echo ========================================
echo       创建新的 GitHub 仓库
echo ========================================
echo.
echo 📋 请按以下步骤操作：
echo.
echo 1️⃣  访问 GitHub 官网 (免费)：https://github.com/
echo 2️⃣  注册/登录 GitHub 账号 (免费)
echo 3️⃣  点击右上角 "+" → "New repository"
echo 4️⃣  填写仓库信息：
echo     - Repository name: quantum-trading (或其他名称)
echo     - Description: 量子交易系统
     - ✅ Public (免费用户只能使用 Public 仓库)
echo     - ✅ Add a README file
echo 5️⃣  点击 "Create repository"
echo 6️⃣  复制仓库地址 (类似: https://github.com/用户名/仓库名.git)
echo.
echo 📝 然后在本地执行以下命令：
echo.
echo git init
echo git remote add origin https://github.com/用户名/仓库名.git
echo git branch -M main
echo git add .
echo git commit -m "Initial commit"
echo git push -u origin main
echo.
echo 🔧 配置完成后，重新运行此脚本即可部署！
echo.
pause
exit /b 0

:SETUP_EXISTING_REPO
echo.
echo ========================================
echo      连接现有 GitHub 仓库
echo ========================================
echo.
echo 📝 请执行以下命令连接现有仓库：
echo.
echo git remote add origin https://github.com/用户名/仓库名.git
echo git branch -M main
echo git push -u origin main
echo.
echo 💡 替换 "用户名/仓库名" 为您的实际仓库地址
echo.
echo 🔧 配置完成后，重新运行此脚本即可部署！
echo.
pause
exit /b 0

:SHOW_TUTORIAL
echo.
echo ========================================
echo        📖 详细配置教程
echo ========================================
echo.
echo 🎯 GitHub Pages 免费部署完整教程：
echo.
echo 📚 1. GitHub 账号注册 (免费)
echo    - 访问：https://github.com/
    - 点击 "Sign up" 注册免费账号
echo    - 验证邮箱完成注册
echo.
echo 📚 2. 创建仓库 (免费)
echo    - 登录后点击右上角 "+" → "New repository"
echo    - 仓库名称：quantum-trading
echo    - 设置为 Public (免费用户必须)
echo    - 勾选 "Add a README file"
echo    - 点击 "Create repository"
echo.
echo 📚 3. 配置 GitHub Pages (免费)
echo    - 进入仓库 → Settings → Pages
echo    - Source 选择 "GitHub Actions"
echo    - 保存设置
echo.
echo 📚 4. 本地配置
echo    - 安装 Git：https://git-scm.com/
echo    - 克隆仓库或添加远程仓库
echo    - 运行本部署脚本
echo.
echo 📚 5. 自动部署
echo    - 每次推送代码自动触发部署
echo    - 2-5 分钟后网站更新
echo    - 访问：https://用户名.github.io/仓库名
echo.
echo 💰 费用说明：
echo    ✅ GitHub 账号：完全免费
echo    ✅ 公开仓库：完全免费
echo    ✅ GitHub Pages：完全免费
echo    ✅ 自动部署：完全免费
echo    ✅ HTTPS 证书：完全免费
echo    ✅ 全球 CDN：完全免费
echo    ✅ 无流量限制：完全免费
echo.
echo 🔗 更多帮助：
echo    - GitHub 官方文档：https://docs.github.com/pages
echo    - 部署说明文档：部署说明.md
echo.
pause
exit /b 0