# 1. Use Node.js base
FROM node:20

# 2. Install Python and FFmpeg (The "Engines")
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# 3. Install yt-dlp manually so the app finds it
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
RUN chmod a+rx /usr/local/bin/yt-dlp

# 4. Set up the app
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
RUN npx prisma generate
RUN npm run build

# 5. Start the app
EXPOSE 3001
CMD ["npm", "run", "start:prod"]
