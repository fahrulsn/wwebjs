# Gunakan base image Node.js
FROM node:18

# Set working directory
WORKDIR /app

# Install dependencies sistem yang dibutuhkan Chromium
RUN apt-get update && apt-get install -y \
    chromium \
    && rm -rf /var/lib/apt/lists/*

# Copy package.json dan package-lock.json sebelum install dependencies
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy seluruh kode aplikasi
COPY . .

# Set Puppeteer untuk menggunakan Chromium bawaan sistem
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Jalankan aplikasi
CMD ["node", "main.js"]
