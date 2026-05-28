# 1. Use Node 20
FROM node:20

# 2. Install dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    ffmpeg \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 3. Set up working directory
WORKDIR /usr/src/app

# 4. PRE-INSTALL BINARIES (This is the fix)
# We create a 'bin' folder and put the engines there so the app thinks it downloaded them
RUN mkdir -p bin
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o ./bin/yt-dlp
RUN cp /usr/bin/ffmpeg ./bin/ffmpeg
RUN chmod +x ./bin/yt-dlp ./bin/ffmpeg

# 5. Copy package files and install
COPY package*.json ./
RUN npm install --ignore-scripts

# 6. Copy prisma and generate
COPY prisma ./prisma/
RUN npx prisma generate

# 7. Copy the rest and build
COPY . .
RUN npm run build

# 8. Final setup
EXPOSE 3001

# Ensure the bin folder is also in the dist folder if the app looks there
RUN mkdir -p dist/bin && cp bin/* dist/bin/

CMD npx prisma migrate deploy && npm run start:prod
