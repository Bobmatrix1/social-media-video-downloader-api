# 1. Use a stable Node image
FROM node:20

# 2. Install Python, FFmpeg, and Curl
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    ffmpeg \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 3. Pre-install yt-dlp so the app doesn't have to download it
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
RUN chmod a+rx /usr/local/bin/yt-dlp

# 4. Set the working directory
WORKDIR /usr/src/app

# 5. Copy only the package files first
COPY package*.json ./

# 6. Install dependencies but IGNORE scripts (this stops it from looking for the DB)
RUN npm install --ignore-scripts

# 7. Copy the prisma folder and generate the client
COPY prisma ./prisma/
RUN npx prisma generate

# 8. Copy the rest of the code and build
COPY . .
RUN npm run build

# 9. Expose the port
EXPOSE 3001

# 10. IMPORTANT: Run migrations AND start the app at the same time
CMD npx prisma migrate deploy && npm run start:prod
