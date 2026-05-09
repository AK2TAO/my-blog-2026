FROM node:20-alpine AS builder
RUN npm config set registry https://registry.npmmirror.com
WORKDIR /app
COPY package.json package-lock.json .npmrc ./
RUN npm ci --only=production
COPY . .
RUN node scripts/copy-overrides.js
RUN node node_modules/.bin/hexo generate

FROM nginx:alpine
COPY --from=builder /app/public /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]
