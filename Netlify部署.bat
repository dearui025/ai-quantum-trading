@echo off
chcp 65001 >nul
color 0E
echo ========================================
echo        🚀 量子交易系统 🚀
echo       Netlify 免费部署工具
echo ========================================
echo.
echo 🎉 欢迎使用 Netlify 免费部署！
echo.
echo ✨ Netlify 优势：
echo    🆓 完全免费 - 个人项目永久免费
echo    ⚡ 超快部署 - 全球 CDN 加速
echo    🔒 自动 HTTPS - 免费 SSL 证书
echo    🌍 边缘计算 - 全球 300+ 节点
echo    📱 自定义域名 - 支持免费绑定
echo    🔄 自动部署 - Git 推送自动更新
echo    📊 实时分析 - 免费流量统计
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
    echo    建议版本：v18+ LTS
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

:: 检查 Netlify CLI
echo 🔍 检查 Netlify CLI...
npx netlify --version >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Netlify CLI 未安装，正在安装...
    npm install -g netlify-cli
    if errorlevel 1 (
        echo ❌ Netlify CLI 安装失败
        echo 💡 请手动安装：npm install -g netlify-cli
        pause
        exit /b 1
    )
)
echo ✅ Netlify CLI 已安装

echo.
echo ========================================
echo        部署方式选择
echo ========================================
echo.
echo 请选择 Netlify 部署方式：
echo.
echo [1] 🚀 拖拽部署 (最简单，推荐新手)
echo [2] 🔗 Git 连接部署 (自动化，推荐)
echo [3] 📦 CLI 部署 (高级用户)
echo [4] 📖 查看详细教程
echo [0] ❌ 返回主菜单
echo.
set /p deploy_choice=请选择部署方式 (0-4): 

if "%deploy_choice%"=="1" goto DRAG_DROP_DEPLOY
if "%deploy_choice%"=="2" goto GIT_DEPLOY
if "%deploy_choice%"=="3" goto CLI_DEPLOY
if "%deploy_choice%"=="4" goto SHOW_TUTORIAL
if "%deploy_choice%"=="0" exit /b 0
echo 无效选项，请重新选择
goto :eof

:DRAG_DROP_DEPLOY
echo.
echo ========================================
echo       🚀 拖拽部署 (最简单)
echo ========================================
echo.

echo 📦 准备构建文件...
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

echo ✅ 构建完成！
echo.
echo 📋 拖拽部署步骤：
echo.
echo 1️⃣  访问 Netlify 官网：https://www.netlify.com/
echo 2️⃣  注册/登录免费账号
echo 3️⃣  在首页找到 "Deploy manually" 区域
echo 4️⃣  将 "out" 文件夹拖拽到部署区域
echo 5️⃣  等待上传和部署完成 (通常 1-2 分钟)
echo 6️⃣  获得免费的 .netlify.app 域名
echo.
echo 📁 构建文件位置：%cd%\out
echo.
echo 💡 提示：
echo    - 首次部署会分配随机域名
echo    - 可在 Netlify 控制台修改域名
echo    - 支持绑定自定义域名
echo    - 每次更新需要重新拖拽 out 文件夹
echo.
echo 🌐 部署完成后，您将获得类似以下地址：
echo    https://amazing-site-123456.netlify.app
echo.
start "" "https://www.netlify.com/"
echo 🔗 已为您打开 Netlify 官网
echo.
pause
exit /b 0

:GIT_DEPLOY
echo.
echo ========================================
echo      🔗 Git 连接部署 (推荐)
echo ========================================
echo.

echo 🔍 检查 Git 配置...
git --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Git 未安装
    echo 📥 请先安装 Git：https://git-scm.com/
    pause
    exit /b 1
)

git remote -v >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Git 仓库未配置
    echo.
    echo 📋 请先配置 Git 仓库：
    echo.
    echo 方式1 - 连接 GitHub：
    echo    git remote add origin https://github.com/用户名/仓库名.git
    echo.
    echo 方式2 - 连接 GitLab：
    echo    git remote add origin https://gitlab.com/用户名/仓库名.git
    echo.
    echo 方式3 - 连接 Bitbucket：
    echo    git remote add origin https://bitbucket.org/用户名/仓库名.git
    echo.
    echo 🔧 配置完成后重新运行此脚本
    pause
    exit /b 1
)

echo ✅ Git 仓库已配置
echo.
echo 📦 准备部署...
npm install --silent
if errorlevel 1 (
    echo ❌ 依赖安装失败
    pause
    exit /b 1
)

echo 📤 推送代码到仓库...
git add .
git commit -m "Netlify deploy: %date% %time%" >nul 2>&1
git push
if errorlevel 1 (
    echo ❌ 代码推送失败
    echo 💡 请检查 Git 配置和网络连接
    pause
    exit /b 1
)

echo ✅ 代码推送成功
echo.
echo 📋 Netlify Git 部署步骤：
echo.
echo 1️⃣  访问 Netlify：https://www.netlify.com/
echo 2️⃣  登录并点击 "New site from Git"
echo 3️⃣  选择您的 Git 提供商 (GitHub/GitLab/Bitbucket)
echo 4️⃣  授权 Netlify 访问您的仓库
echo 5️⃣  选择要部署的仓库
echo 6️⃣  配置构建设置：
echo     - Build command: npm run build
echo     - Publish directory: out
echo 7️⃣  点击 "Deploy site"
echo 8️⃣  等待部署完成 (通常 2-5 分钟)
echo.
echo 🎉 优势：
echo    ✅ 自动部署 - 每次推送代码自动更新网站
echo    ✅ 分支预览 - 支持多分支部署预览
echo    ✅ 回滚功能 - 可快速回滚到任意版本
echo    ✅ 构建日志 - 详细的构建和部署日志
echo.
start "" "https://app.netlify.com/start"
echo 🔗 已为您打开 Netlify 部署页面
echo.
pause
exit /b 0

:CLI_DEPLOY
echo.
echo ========================================
echo        📦 CLI 部署 (高级)
echo ========================================
echo.

echo 🔐 Netlify 登录...
netlify login
if errorlevel 1 (
    echo ❌ Netlify 登录失败
    pause
    exit /b 1
)

echo ✅ 登录成功
echo.
echo 📦 准备构建...
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

echo 🚀 部署到 Netlify...
netlify deploy --prod --dir=out
if errorlevel 1 (
    echo ❌ 部署失败
    echo 💡 请检查网络连接和 Netlify 配置
    pause
    exit /b 1
)

echo.
echo 🎉 CLI 部署成功！
echo.
echo 💡 CLI 部署优势：
echo    ⚡ 快速部署 - 直接从命令行部署
echo    🔧 灵活配置 - 支持各种部署选项
echo    📊 实时反馈 - 即时查看部署状态
echo    🎯 精确控制 - 可指定具体的部署参数
echo.
echo 🔗 常用 CLI 命令：
echo    netlify status     - 查看站点状态
echo    netlify open       - 在浏览器中打开站点
echo    netlify deploy     - 预览部署
echo    netlify deploy --prod - 生产部署
echo.
pause
exit /b 0

:SHOW_TUTORIAL
echo.
echo ========================================
echo        📖 Netlify 详细教程
echo ========================================
echo.
echo 🎯 Netlify 完整部署指南：
echo.
echo 📚 1. 账号注册 (免费)
echo    - 访问：https://www.netlify.com/
echo    - 点击 "Sign up" 注册
echo    - 支持 GitHub/GitLab/Bitbucket 登录
echo    - 邮箱验证完成注册
echo.
echo 📚 2. 部署方式对比
echo    🚀 拖拽部署：
echo       ✅ 最简单，适合新手
echo       ✅ 无需 Git 知识
echo       ❌ 需要手动更新
echo.
echo    🔗 Git 连接：
echo       ✅ 自动化部署
echo       ✅ 支持多分支
echo       ✅ 版本控制
echo       ❌ 需要 Git 基础
echo.
echo    📦 CLI 部署：
echo       ✅ 最灵活
echo       ✅ 适合开发者
echo       ❌ 需要技术基础
echo.
echo 📚 3. 免费额度 (个人项目足够)
echo    ✅ 带宽：100GB/月
echo    ✅ 构建时间：300分钟/月
echo    ✅ 站点数量：无限制
echo    ✅ 表单提交：100次/月
echo    ✅ 身份验证：1000个用户
echo    ✅ 函数调用：125K次/月
echo.
echo 📚 4. 高级功能
echo    🌐 自定义域名：免费绑定
echo    🔒 SSL 证书：自动配置
echo    📊 分析统计：免费版本
echo    🔄 A/B 测试：付费功能
echo    ⚡ 边缘函数：部分免费
echo    📝 表单处理：基础免费
echo.
echo 📚 5. 性能优化
echo    ⚡ 全球 CDN：自动启用
echo    📦 资源压缩：自动优化
echo    🖼️  图片优化：自动处理
echo    🔄 缓存策略：智能缓存
echo.
echo 💰 费用说明：
echo    🆓 个人项目：完全免费
echo    💼 团队项目：$19/月起
echo    🏢 企业项目：$99/月起
echo.
echo 🔗 有用链接：
echo    - 官方文档：https://docs.netlify.com/
echo    - 社区论坛：https://community.netlify.com/
echo    - 状态页面：https://www.netlifystatus.com/
echo.
echo 🆘 技术支持：
echo    - 免费用户：社区支持
echo    - 付费用户：邮件支持
echo    - 企业用户：优先支持
echo.
pause
exit /b 0