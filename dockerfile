# Stage 1: Build
FROM node:18 AS builder

# Set working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy application source
COPY . .

# Build the application (if needed)
# RUN npm run build

# Stage 2: Production
FROM node:18-alpine

# Set working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production

# Copy built application from builder stage
COPY --from=builder /usr/src/app .

# Expose port 3000
EXPOSE 3000

# Set NODE_ENV to production
ENV NODE_ENV production

# Run the application
CMD ["node", "app.js"]
