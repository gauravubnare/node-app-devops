FROM node:14.16.0
WORKDIR /app
RUN mkdir /app/public && mkdir /app/src
COPY other/package.json /app
COPY src/  /app/src
COPY public /app/public
ENV PATH /app/node_modules/.bin:$PATH
RUN npm install
EXPOSE 3000
ENTRYPOINT npm start


