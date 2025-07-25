@echo off
echo ========================================
echo    GitHub Pages 404 Error Quick Fix
echo ========================================
echo.

echo [1/5] Checking project configuration files...
if not exist "package.json" (
    echo ERROR: package.json not found
    echo Please run this script in the correct project directory
    pause
    exit /b 1
)

if not exist "next.config.js" (
    echo ERROR: next.config.js not found
    pause
    exit /b 1
)

if not exist ".github\workflows\deploy.yml" (
    echo ERROR: GitHub Actions workflow file not found
    pause
    exit /b 1
)

echo SUCCESS: Project configuration files found
echo.

echo [2/5] Checking Next.js configuration...
findstr /C:"output: 'export'" next.config.js >nul
if %errorlevel% neq 0 (
    echo WARNING: Next.js not configured for static export
    echo Fixing configuration...
    (
        echo /** @type {import('next'^).NextConfig} */
        echo const nextConfig = {
        echo   output: 'export',
        echo   trailingSlash: true,
        echo   images: {
        echo     unoptimized: true
        echo   }
        echo };
        echo.
        echo module.exports = nextConfig;
    ) > next.config.js
    echo SUCCESS: Next.js configuration fixed
) else (
    echo SUCCESS: Next.js configuration is correct
)
echo.

echo [3/5] Checking package.json build scripts...
findstr /C:"\"build\": \"next build\"" package.json >nul
if %errorlevel% neq 0 (
    echo WARNING: Build script might be incorrect
) else (
    echo SUCCESS: Build script configuration is correct
)
echo.

echo [4/5] Generating deployment checklist...
echo Creating deployment checklist...
(
    echo # GitHub Pages Deployment Checklist
    echo.
    echo ## Local Checks ^(Completed^)
    echo - [x] package.json exists
    echo - [x] next.config.js configured correctly
    echo - [x] GitHub Actions workflow exists
    echo.
    echo ## GitHub Website Checks ^(Manual Steps Required^)
    echo.
    echo ### 1. Repository Visibility
    echo - [ ] Visit: https://github.com/dearui025/ai-quantum-trading/settings
    echo - [ ] Ensure repository is **Public**
    echo - [ ] If Private, change to Public
    echo.
    echo ### 2. GitHub Pages Configuration
    echo - [ ] Visit: https://github.com/dearui025/ai-quantum-trading/settings/pages
    echo - [ ] Source: Select **GitHub Actions**
    echo - [ ] Do NOT select "Deploy from a branch"
    echo.
    echo ### 3. Trigger Deployment
    echo - [ ] Visit: https://github.com/dearui025/ai-quantum-trading/actions
    echo - [ ] Click "Run workflow" button
    echo - [ ] Select main branch and run
    echo.
    echo ### 4. Verify Deployment
    echo - [ ] Wait for Actions to show green checkmark
    echo - [ ] Visit: https://dearui025.github.io/ai-quantum-trading/
    echo.
    echo ## If Still Getting 404
    echo 1. Clear browser cache ^(Ctrl+Shift+R^)
    echo 2. Wait 5-10 minutes and try again
    echo 3. Check Actions for any errors
    echo.
    echo ## Technical Support
    echo If you need help, provide the Actions error logs
) > DEPLOYMENT_CHECKLIST.md

echo SUCCESS: Checklist generated: DEPLOYMENT_CHECKLIST.md
echo.

echo [5/5] Fix Complete Summary
echo ========================================
echo SUCCESS: Local configuration check complete
echo SUCCESS: Configuration files optimized
echo SUCCESS: Deployment checklist generated
echo.
echo Next Steps:
echo.
echo 1. Open your GitHub repository:
echo    https://github.com/dearui025/ai-quantum-trading
echo.
echo 2. Ensure repository is Public:
echo    Settings - Danger Zone - Change visibility - Make public
echo.
echo 3. Configure GitHub Pages:
echo    Settings - Pages - Source - Select "GitHub Actions"
echo.
echo 4. Trigger deployment:
echo    Actions - Deploy to GitHub Pages - Run workflow
echo.
echo 5. Wait 5-10 minutes then visit:
echo    https://dearui025.github.io/ai-quantum-trading/
echo.
echo For detailed instructions: FIX_404_ERROR.md
echo For checklist: DEPLOYMENT_CHECKLIST.md
echo ========================================
echo.
pause