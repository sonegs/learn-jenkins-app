FROM mcr.microsoft.com/playwright:v1.39.0-jammy
RUN npm install -g netlify-cli@20.1.1 node-jq serve@14.2.4
RUN apt update
RUN apt install jq -y