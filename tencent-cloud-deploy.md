# 腾讯云部署指南

## 方案一：使用腾讯云静态网站托管

### 1. 准备工作
- 注册腾讯云账号
- 开通对象存储 COS 服务
- 开通 CDN 服务（可选，用于加速）

### 2. 构建项目
```bash
cd frontend
npm install
npm run build
```

### 3. 上传到 COS
1. 登录腾讯云控制台
2. 进入对象存储 COS
3. 创建存储桶（选择公有读私有写）
4. 将 `out` 目录下的所有文件上传到存储桶根目录
5. 在存储桶设置中开启静态网站功能
6. 设置索引文档为 `index.html`
7. 设置错误文档为 `404.html`

### 4. 配置自定义域名（可选）
1. 在 COS 控制台绑定自定义域名
2. 配置 DNS 解析
3. 申请 SSL 证书（推荐）

## 方案二：使用腾讯云轻量应用服务器

### 1. 购买轻量应用服务器
- 选择 Ubuntu 20.04 镜像
- 配置：1核2G内存即可

### 2. 服务器环境配置
```bash
# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装 Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# 安装 Nginx
sudo apt install nginx -y

# 启动 Nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

### 3. 部署项目
```bash
# 克隆项目（或上传文件）
git clone <your-repo-url>
cd frontend

# 安装依赖并构建
npm install
npm run build

# 复制构建文件到 Nginx 目录
sudo cp -r out/* /var/www/html/
```

### 4. 配置 Nginx
```bash
sudo nano /etc/nginx/sites-available/default
```

添加以下配置：
```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # 处理静态资源
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

重启 Nginx：
```bash
sudo systemctl restart nginx
```

## 方案三：使用腾讯云 Serverless（推荐）

### 1. 安装 Serverless Framework
```bash
npm install -g serverless
```

### 2. 配置腾讯云密钥
```bash
serverless config credentials --provider tencent --key <SecretId> --secret <SecretKey>
```

### 3. 创建 serverless.yml 配置文件
（见下方自动生成的配置文件）

### 4. 部署
```bash
serverless deploy
```

## 自动化部署脚本

我将为您创建自动化部署脚本，包括：
1. Serverless 配置文件
2. 腾讯云 COS 上传脚本
3. 服务器部署脚本

选择最适合您需求的方案即可！