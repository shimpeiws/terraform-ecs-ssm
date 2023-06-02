FROM node:20.2.0-buster

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

CMD ["npm", "run", "start"]
