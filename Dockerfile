# 示例，请根据你的实际项目进行调整
FROM node:18-alpine AS builder

WORKDIR /app

# 将生成的 .env.production 文件复制到容器中
COPY .env.production .env.production

# 复制源代码和配置文件
COPY . .

# 构建前端应用
RUN npm install
RUN npm run build

# Nginx 阶段
FROM nginx:alpine
COPY --from=builder /app/.next/static /usr/share/nginx/html/.next/static
COPY --from=builder /app/public /usr/share/nginx/html/public
COPY --from=builder /app/.next/standalone /usr/share/nginx/html
# 确保你的 nginx 配置能正确处理前端路由
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 暴露端口
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]