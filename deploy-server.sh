#!/bin/bash

# 腾讯云轻量应用服务器部署脚本
# 在服务器上运行此脚本进行部署

set -e

echo "========================================"
echo "     腾讯云服务器部署脚本"
echo "========================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 配置变量
PROJECT_NAME="quantum-trading"
WEB_ROOT="/var/www/html"
NGINX_CONFIG="/etc/nginx/sites-available/default"
DOMAIN="your-domain.com"  # 请修改为您的域名

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}请使用 sudo 运行此脚本${NC}"
    exit 1
fi

echo -e "${GREEN}🔍 检查系统环境...${NC}"

# 更新系统
echo -e "${YELLOW}📦 更新系统包...${NC}"
apt update && apt upgrade -y

# 安装 Node.js
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}📦 安装 Node.js...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs
else
    echo -e "${GREEN}✅ Node.js 已安装: $(node --version)${NC}"
fi

# 安装 Nginx
if ! command -v nginx &> /dev/null; then
    echo -e "${YELLOW}📦 安装 Nginx...${NC}"
    apt install nginx -y
    systemctl start nginx
    systemctl enable nginx
else
    echo -e "${GREEN}✅ Nginx 已安装${NC}"
fi

# 安装 Git
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}📦 安装 Git...${NC}"
    apt install git -y
else
    echo -e "${GREEN}✅ Git 已安装${NC}"
fi

# 创建项目目录
echo -e "${YELLOW}📁 创建项目目录...${NC}"
mkdir -p /opt/$PROJECT_NAME
cd /opt/$PROJECT_NAME

# 克隆或更新项目
if [ -d ".git" ]; then
    echo -e "${YELLOW}🔄 更新项目代码...${NC}"
    git pull
else
    echo -e "${YELLOW}📥 克隆项目代码...${NC}"
    echo "请手动上传项目文件到 /opt/$PROJECT_NAME 目录"
    echo "或者使用 git clone 命令克隆您的仓库"
    # git clone <your-repo-url> .
fi

# 进入前端目录
if [ -d "frontend" ]; then
    cd frontend
else
    echo -e "${RED}❌ 未找到 frontend 目录${NC}"
    exit 1
fi

# 安装依赖
echo -e "${YELLOW}📦 安装项目依赖...${NC}"
npm install

# 构建项目
echo -e "${YELLOW}🔨 构建项目...${NC}"
npm run build

# 检查构建结果
if [ ! -d "out" ]; then
    echo -e "${RED}❌ 构建失败：out 目录不存在${NC}"
    exit 1
fi

# 部署到 Nginx
echo -e "${YELLOW}🚀 部署到 Nginx...${NC}"
rm -rf $WEB_ROOT/*
cp -r out/* $WEB_ROOT/
chown -R www-data:www-data $WEB_ROOT
chmod -R 755 $WEB_ROOT

# 配置 Nginx
echo -e "${YELLOW}⚙️  配置 Nginx...${NC}"
cat > $NGINX_CONFIG << EOF
server {
    listen 80;
    server_name $DOMAIN;
    root $WEB_ROOT;
    index index.html;

    # 处理 Next.js 路由
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # 静态资源缓存
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)\$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        access_log off;
    }

    # 安全头
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;

    # Gzip 压缩
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied expired no-cache no-store private must-revalidate auth;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/javascript;
}
EOF

# 测试 Nginx 配置
echo -e "${YELLOW}🧪 测试 Nginx 配置...${NC}"
nginx -t

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Nginx 配置正确${NC}"
    systemctl reload nginx
else
    echo -e "${RED}❌ Nginx 配置错误${NC}"
    exit 1
fi

# 配置防火墙
echo -e "${YELLOW}🔥 配置防火墙...${NC}"
if command -v ufw &> /dev/null; then
    ufw allow 'Nginx Full'
    ufw --force enable
fi

echo -e "${GREEN}🎉 部署完成！${NC}"
echo -e "${GREEN}🔗 访问地址: http://$DOMAIN${NC}"
echo ""
echo -e "${YELLOW}💡 后续步骤：${NC}"
echo "1. 配置域名 DNS 解析指向此服务器"
echo "2. 申请 SSL 证书（推荐使用 Let's Encrypt）"
echo "3. 配置 HTTPS 重定向"
echo ""
echo -e "${YELLOW}🔧 SSL 证书配置命令：${NC}"
echo "sudo apt install certbot python3-certbot-nginx"
echo "sudo certbot --nginx -d $DOMAIN"
echo ""
echo -e "${YELLOW}📝 更新部署命令：${NC}"
echo "sudo bash /opt/$PROJECT_NAME/frontend/deploy-server.sh"