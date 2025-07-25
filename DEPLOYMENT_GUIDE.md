# GitHub Pages 部署指南

## 📋 部署前准备

### 1. 安装Git
- 下载并安装 [Git for Windows](https://git-scm.com/download/win)
- 安装完成后重启命令行

### 2. 创建GitHub仓库
1. 登录 [GitHub](https://github.com)
2. 点击右上角 "+" 创建新仓库
3. 仓库名称：`ai-quantum-trading`
4. 设置为公开仓库（Public）
5. 不要初始化README（我们已有文件）

## 🚀 部署步骤

### 步骤1：初始化Git仓库
```bash
cd frontend
git init
git add .
git commit -m "Initial commit: AI Quantum Trading Platform"
```

### 步骤2：连接GitHub仓库
```bash
# 替换YOUR_USERNAME为你的GitHub用户名
git remote add origin https://github.com/YOUR_USERNAME/ai-quantum-trading.git
git branch -M main
git push -u origin main
```

### 步骤3：启用GitHub Pages
1. 进入GitHub仓库页面
2. 点击 "Settings" 选项卡
3. 滚动到 "Pages" 部分
4. 在 "Source" 下选择 "GitHub Actions"
5. 保存设置

### 步骤4：自动部署
- 代码推送后，GitHub Actions会自动运行
- 构建完成后，网站将在以下地址可用：
  `https://YOUR_USERNAME.github.io/ai-quantum-trading/`

## 🔧 本地构建测试

在推送到GitHub之前，建议先本地测试：

```bash
# 安装依赖
npm install

# 构建静态文件
npm run export

# 本地预览（可选）
npx serve out
```

## 📝 重要配置文件

项目已包含以下配置文件：

- ✅ `.github/workflows/deploy.yml` - GitHub Actions部署配置
- ✅ `next.config.js` - Next.js静态导出配置
- ✅ `package.json` - 包含export和deploy脚本
- ✅ `.gitignore` - Git忽略文件配置

## 🌐 访问网站

部署成功后，您的网站将在以下地址可用：
- **GitHub Pages地址**：`https://YOUR_USERNAME.github.io/ai-quantum-trading/`
- **自定义域名**：可在GitHub Pages设置中配置

## 🔄 更新网站

要更新网站内容：
1. 修改代码
2. 提交更改：`git add . && git commit -m "Update content"`
3. 推送到GitHub：`git push`
4. GitHub Actions会自动重新部署

## ❗ 常见问题

### 问题1：部署失败
- 检查GitHub Actions日志
- 确保所有依赖都在package.json中
- 验证next.config.js配置正确

### 问题2：页面显示404
- 确保GitHub Pages设置正确
- 检查仓库是否为公开
- 等待几分钟让DNS生效

### 问题3：样式丢失
- 确保next.config.js中有正确的basePath配置
- 检查静态资源路径是否正确

## 📞 技术支持

如遇到问题，请检查：
1. GitHub Actions构建日志
2. 浏览器开发者工具控制台
3. GitHub Pages设置页面

---

🎉 **恭喜！按照以上步骤，您的AI量子交易平台将成功部署到GitHub Pages！**