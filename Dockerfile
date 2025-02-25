# Gunakan image node dengan dependencies lengkap
FROM node:18-slim

# Set working directory
WORKDIR /app

# Install dependencies yang dibutuhkan untuk Chromium
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    ca-certificates \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    xdg-utils \
    chromium \
    && rm -rf /var/lib/apt/lists/*

# Install Puppeteer dependencies
RUN npm install -g puppeteer@latest

# Copy package.json dan package-lock.json
COPY package.json package-lock.json ./

# Install dependencies aplikasi
RUN npm install

# Copy seluruh kode aplikasi
COPY . .

# Set Puppeteer untuk menggunakan Chromium bawaan sistem
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Jalankan aplikasi
CMD ["node", "main.js"]
