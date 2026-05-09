# ============================================================
# Stage 1: Build — 用 Node.js 生成静态网站
# ============================================================
FROM node:20-alpine AS builder

# 中国用户加速 npm 下载（海外可删除这行）
RUN npm config set registry https://registry.npmmirror.com

WORKDIR /app

# 先复制依赖清单（Docker 层缓存：不改 package.json 就不会重新 npm install）
COPY package.json package-lock.json .npmrc ./

RUN npm ci --only=production

# 复制所有源文件（包括 layout/ 模板覆盖）
COPY . .

# 生成静态文件到 public/ 目录
RUN node node_modules/.bin/hexo generate

# ============================================================
# Stage 2: 生产环境 — 用 nginx 提供静态文件服务
# ============================================================
FROM nginx:alpine

# 从 builder 阶段拿生成的静态文件
COPY --from=builder /app/public /usr/share/nginx/html

# 让 nginx 一直运行
CMD ["nginx", "-g", "daemon off;"]
