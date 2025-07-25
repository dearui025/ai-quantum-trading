@echo off
chcp 65001 >nul
echo ========================================
echo    AI Quantum Trading GitHub Pages Deploy
echo ========================================
echo.

echo Checking if Git is installed...
git --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git not found. Please install Git for Windows first
    echo Download: https://git-scm.com/download/win
    pause
    exit /b 1
)
echo [OK] Git is installed

echo.
echo Please make sure you have:
echo 1. Created a new repository on GitHub (public repository)
echo 2. Have the complete repository URL ready
echo.
set /p REPO_URL="Enter GitHub repository URL (e.g., https://github.com/username/ai-quantum-trading.git): "

if "%REPO_URL%"=="" (
    echo [ERROR] Repository URL cannot be empty
    pause
    exit /b 1
)

echo.
echo Starting deployment process...
echo.

echo [1/6] Initializing Git repository...
git init
if errorlevel 1 (
    echo [ERROR] Git initialization failed
    pause
    exit /b 1
)

echo [2/6] Adding all files...
git add .
if errorlevel 1 (
    echo [ERROR] Adding files failed
    pause
    exit /b 1
)

echo [3/6] Creating initial commit...
git commit -m "Initial commit: AI Quantum Trading Platform"
if errorlevel 1 (
    echo [ERROR] Commit failed
    pause
    exit /b 1
)

echo [4/6] Setting main branch...
git branch -M main
if errorlevel 1 (
    echo [ERROR] Setting main branch failed
    pause
    exit /b 1
)

echo [5/6] Connecting to remote repository...
git remote add origin %REPO_URL%
if errorlevel 1 (
    echo [ERROR] Connecting to remote repository failed. Please check URL
    pause
    exit /b 1
)

echo [6/6] Pushing to GitHub...
git push -u origin main
if errorlevel 1 (
    echo [ERROR] Push failed. Please check:
    echo - GitHub repository exists
    echo - You have push permissions
    echo - Network connection is working
    pause
    exit /b 1
)

echo.
echo ========================================
echo           Deployment Successful!
echo ========================================
echo.
echo Next steps:
echo 1. Visit your GitHub repository
echo 2. Go to Settings ^> Pages
echo 3. Select "GitHub Actions" as Source
echo 4. Wait for automatic build to complete
echo.
echo Your website will be available at:
echo https://YOUR_USERNAME.github.io/REPO_NAME/
echo.
echo Build status can be viewed in the Actions tab
echo.
pause