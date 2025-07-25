@echo off
echo ========================================
echo    AI Quantum Trading - Auto Deploy
echo ========================================
echo.

echo [1/5] Checking Git installation...
git --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Git not found. Please install Git first.
    echo Download from: https://git-scm.com/download/win
    pause
    exit /b 1
)
echo Git is installed

echo.
echo [2/5] Initializing Git repository...
if not exist ".git" (
    git init
    echo Git repository initialized
) else (
    echo Git repository already exists
)

echo.
echo [3/5] Adding all files...
git add .
echo Files added to Git

echo.
echo [4/5] Committing changes...
git commit -m "Update GitHub Actions workflow for Pages deployment" 2>nul
if errorlevel 1 (
    echo No new changes to commit
) else (
    echo Changes committed
)

echo.
echo [5/5] Setting up remote and pushing...
set /p REPO_URL="Enter your GitHub repository URL: "
if "%REPO_URL%"=="" (
    echo ERROR: Repository URL is required
    pause
    exit /b 1
)

git branch -M main
git remote remove origin 2>nul
git remote add origin %REPO_URL%
git push -u origin main

if errorlevel 1 (
    echo.
    echo ERROR: Failed to push to GitHub
    echo Please check your repository URL and permissions
    pause
    exit /b 1
)

echo.
echo ========================================
echo           DEPLOYMENT SUCCESS!
echo ========================================
echo.
echo Code pushed to GitHub successfully
echo GitHub Actions workflow updated
echo.
echo NEXT STEPS:
echo 1. Go to your GitHub repository
echo 2. Click Settings tab
echo 3. Scroll down to Pages section
echo 4. Under Source, select GitHub Actions
echo 5. Wait 2-5 minutes for deployment
echo.
echo Press any key to open GitHub repository...
pause >nul
start "" "%REPO_URL:~0,-4%"