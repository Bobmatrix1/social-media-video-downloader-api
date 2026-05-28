 1 # 1. Use Node 20
    2 FROM node:20
    3
    4 # 2. Install dependencies
    5 RUN apt-get update && apt-get install -y \
    6     python3 \
    7     python3-pip \
    8     ffmpeg \
    9     curl \
   10     && rm -rf /var/lib/apt/lists/*
   11
   12 # 3. Set up working directory
   13 WORKDIR /usr/src/app
   14
   15 # 4. PRE-INSTALL BINARIES (This is the fix)
   16 # We create a 'bin' folder and put the engines there so the app thinks it downloaded them
   17 RUN mkdir -p bin
   18 RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o ./bin/yt-dlp
   19 RUN cp /usr/bin/ffmpeg ./bin/ffmpeg
   20 RUN chmod +x ./bin/yt-dlp ./bin/ffmpeg
   21
   22 # 5. Copy package files and install
   23 COPY package*.json ./
   24 RUN npm install --ignore-scripts
   25
   26 # 6. Copy prisma and generate
   27 COPY prisma ./prisma/
   28 RUN npx prisma generate
   29
   30 # 7. Copy the rest and build
   31 COPY . .
   32 RUN npm run build
   33
   34 # 8. Final setup
   35 EXPOSE 3001
   36 # Ensure the bin folder is also in the dist folder if the app looks there
   37 RUN mkdir -p dist/bin && cp bin/* dist/bin/
   38
   39 CMD npx prisma migrate deploy && npm run start:prod
