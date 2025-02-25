# Gunakan image Node.js resmi sebagai base image
FROM node:18

# Set direktori kerja dalam container
WORKDIR /app

# Salin file package.json dan package-lock.json ke direktori kerja
COPY package*.json ./

# Instal dependensi aplikasi
RUN npm install

# Salin semua file sumber aplikasi ke dalam container
COPY . .

# Instal Chromium dan dependensi yang diperlukan
RUN apt-get update && apt-get install -y \
  chromium \
  ca-certificates \
  fonts-liberation \
  libappindicator3-1 \
  libasound2 \
  libatk-bridge2.0-0 \
  libatk1.0-0 \
  libcups2 \
  libdbus-1-3 \
  libdrm2 \
  libgbm1 \
  libgtk-3-0 \
  libnspr4 \
  libnss3 \
  libx11-xcb1 \
  libxcomposite1 \
  libxdamage1 \
  libxrandr2 \
  xdg-utils \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

# Set variabel lingkungan untuk Puppeteer
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Ekspos port yang digunakan oleh aplikasi
EXPOSE 8080

# Jalankan aplikasi
CMD ["npm", "start"]
