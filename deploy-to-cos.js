#!/usr/bin/env node

/**
 * 腾讯云 COS 自动部署脚本
 * 使用前请先安装依赖：npm install cos-nodejs-sdk-v5
 * 配置环境变量：TENCENT_SECRET_ID 和 TENCENT_SECRET_KEY
 */

const COS = require('cos-nodejs-sdk-v5');
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// 配置信息
const config = {
  SecretId: process.env.TENCENT_SECRET_ID || 'your-secret-id',
  SecretKey: process.env.TENCENT_SECRET_KEY || 'your-secret-key',
  Bucket: process.env.COS_BUCKET || 'quantum-trading-1234567890',
  Region: process.env.COS_REGION || 'ap-guangzhou'
};

// 初始化 COS
const cos = new COS({
  SecretId: config.SecretId,
  SecretKey: config.SecretKey
});

// 获取文件 MIME 类型
function getMimeType(filePath) {
  const ext = path.extname(filePath).toLowerCase();
  const mimeTypes = {
    '.html': 'text/html',
    '.css': 'text/css',
    '.js': 'application/javascript',
    '.json': 'application/json',
    '.png': 'image/png',
    '.jpg': 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.gif': 'image/gif',
    '.svg': 'image/svg+xml',
    '.ico': 'image/x-icon',
    '.txt': 'text/plain'
  };
  return mimeTypes[ext] || 'application/octet-stream';
}

// 递归获取目录下所有文件
function getAllFiles(dir, fileList = []) {
  const files = fs.readdirSync(dir);
  
  files.forEach(file => {
    const filePath = path.join(dir, file);
    const stat = fs.statSync(filePath);
    
    if (stat.isDirectory()) {
      getAllFiles(filePath, fileList);
    } else {
      fileList.push(filePath);
    }
  });
  
  return fileList;
}

// 上传文件到 COS
function uploadFile(localPath, remotePath) {
  return new Promise((resolve, reject) => {
    const fileContent = fs.readFileSync(localPath);
    const contentType = getMimeType(localPath);
    
    cos.putObject({
      Bucket: config.Bucket,
      Region: config.Region,
      Key: remotePath,
      Body: fileContent,
      ContentType: contentType,
      CacheControl: contentType.includes('html') ? 'no-cache' : 'max-age=31536000'
    }, (err, data) => {
      if (err) {
        reject(err);
      } else {
        console.log(`✅ 上传成功: ${remotePath}`);
        resolve(data);
      }
    });
  });
}

// 主部署函数
async function deploy() {
  try {
    console.log('🚀 开始部署到腾讯云 COS...');
    
    // 1. 构建项目
    console.log('📦 构建项目...');
    execSync('npm run build', { stdio: 'inherit' });
    
    // 2. 检查 out 目录
    const outDir = path.join(__dirname, 'out');
    if (!fs.existsSync(outDir)) {
      throw new Error('构建失败：out 目录不存在');
    }
    
    // 3. 获取所有文件
    const files = getAllFiles(outDir);
    console.log(`📁 找到 ${files.length} 个文件`);
    
    // 4. 上传文件
    console.log('⬆️  开始上传文件...');
    const uploadPromises = files.map(filePath => {
      const relativePath = path.relative(outDir, filePath).replace(/\\/g, '/');
      return uploadFile(filePath, relativePath);
    });
    
    await Promise.all(uploadPromises);
    
    // 5. 配置存储桶网站
    console.log('🌐 配置静态网站...');
    await new Promise((resolve, reject) => {
      cos.putBucketWebsite({
        Bucket: config.Bucket,
        Region: config.Region,
        WebsiteConfiguration: {
          IndexDocument: {
            Suffix: 'index.html'
          },
          ErrorDocument: {
            Key: '404.html'
          }
        }
      }, (err, data) => {
        if (err) reject(err);
        else resolve(data);
      });
    });
    
    console.log('🎉 部署完成！');
    console.log(`🔗 访问地址: https://${config.Bucket}.cos-website.${config.Region}.myqcloud.com`);
    
  } catch (error) {
    console.error('❌ 部署失败:', error.message);
    process.exit(1);
  }
}

// 检查配置
if (config.SecretId === 'your-secret-id' || config.SecretKey === 'your-secret-key') {
  console.error('❌ 请先配置腾讯云密钥！');
  console.log('设置环境变量：');
  console.log('export TENCENT_SECRET_ID=your-secret-id');
  console.log('export TENCENT_SECRET_KEY=your-secret-key');
  console.log('export COS_BUCKET=your-bucket-name');
  process.exit(1);
}

// 运行部署
deploy();