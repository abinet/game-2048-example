FROM node:24-slim AS builder
WORKDIR /usr/src/app
COPY . .
RUN npm install --include=dev
#
# Build mode can be set via NODE_ENV environment variable (development or production)
# See project package.json and webpack.config.js
#
ENV NODE_ENV=development
RUN npm run build

FROM nginx:latest

# Copy built files from the build stage to the production image
WORKDIR /usr/share/nginx/html
COPY --from=builder /usr/src/app/dist ./
# Other configurations, if needed

# Container startup command for the web server (nginx in this case)
CMD ["nginx", "-g", "daemon off;"]
