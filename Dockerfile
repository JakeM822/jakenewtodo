# syntax=docker/dockerfile:1
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build
FROM nginx:1.27-alpine
COPY --from=build /app/build /usr/share/nginx/html
RUN printf 'server {\n    listen 3000;\n    location / {\n        root /usr/share/nginx/html;\n        index index.html;\n        try_files $uri /index.html;\n    }\n}\n' > /etc/nginx/conf.d/default.conf
EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]
