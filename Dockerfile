FROM node:latest

WORKDIR /app

RUN apt-get update && \
    apt-get install -y curl iproute2 sed supervisor unzip uuid-runtime wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY *.json .

RUN npm install -r package.json && \
    npm cache clean --force

COPY . .

RUN chmod +x *.sh && ./download.sh && chmod +x cloudflared web.js

EXPOSE 3000

ENTRYPOINT [ "node", "server.js" ]
