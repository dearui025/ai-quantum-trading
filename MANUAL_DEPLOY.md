# 手动部署指南（无需Git命令行）

由于Git环境变量可能未生效，这里提供几种替代的部署方案：

## 方案1：GitHub Desktop（推荐）

### 1. 下载安装GitHub Desktop
- 访问：https://desktop.github.com/
- 下载并安装GitHub Desktop
- 使用GitHub账户登录

### 2. 创建仓库
1. 在GitHub网站创建新仓库：`ai-quantum-trading`
2. 设置为公开仓库（Public）
3. 不要初始化README

### 3. 使用GitHub Desktop部署
1. 打开GitHub Desktop
2. 选择"Add an Existing Repository from your hard drive"
3. 选择项目文件夹：`c:\Users\Administrator\Desktop\量子交易软件1\frontend`
4. 点击"Publish repository"
5. 确保"Keep this code private"未勾选
6. 点击"Publish repository"

## 方案2：直接上传文件

### 1. 创建GitHub仓库
1. 登录GitHub，创建新仓库
2. 仓库名：`ai-quantum-trading`
3. 设置为公开仓库

### 2. 上传文件
1. 在仓库页面点击"uploading an existing file"
2. 将整个frontend文件夹拖拽到页面
3. 等待上传完成
4. 填写提交信息："Initial commit: AI Quantum Trading Platform"
5. 点击"Commit changes"

## 方案3：重启后使用命令行

### 1. 重启电脑
- Git安装后需要重启才能生效环境变量
- 重启后重新打开命令行

### 2. 验证Git安装
```bash
git --version
```

### 3. 运行部署脚本
```bash
.\deploy.bat
```

## 启用GitHub Pages

无论使用哪种方案，代码上传后都需要：

1. **进入仓库设置**
   - 访问：`https://github.com/YOUR_USERNAME/ai-quantum-trading`
   - 点击"Settings"选项卡

2. **配置GitHub Pages**
   - 滚动到"Pages"部分
   - 在"Source"下选择"GitHub Actions"
   - 保存设置

3. **等待构建**
   - 进入"Actions"选项卡查看构建进度
   - 构建完成后网站将可用

4. **访问网站**
   - 地址：`https://YOUR_USERNAME.github.io/ai-quantum-trading/`

## 项目文件说明

项目已包含所有必要的配置文件：
- ✅ `.github/workflows/deploy.yml` - 自动部署配置
- ✅ `next.config.js` - Next.js静态导出配置
- ✅ `package.json` - 项目依赖和脚本
- ✅ `.gitignore` - Git忽略文件

## 预期结果

部署成功后，您将获得：
- 🌐 公网可访问的网站
- 🆓 完全免费的托管服务
- 🚀 自动部署（推送代码即更新）
- 🔒 HTTPS安全访问
- 📱 响应式设计支持所有设备

---

**推荐使用方案1（GitHub Desktop），最简单易用！**