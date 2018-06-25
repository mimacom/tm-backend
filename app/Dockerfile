FROM node:10

WORKDIR /opt/tm-backend

COPY package*.json ./

RUN npm i

COPY . .

EXPOSE 4000

CMD ["npm", "start"]