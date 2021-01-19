FROM node:lts-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json ./
COPY . ./
RUN npm install
RUN npm run build

FROM nginx:stable AS frontend-server
RUN mkdir /app
COPY --from=builder /app/dist /app
COPY deployment-configurations/nginx.conf /etc/nginx/nginx.conf