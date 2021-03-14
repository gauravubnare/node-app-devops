FROM node:14.16.0 as build
WORKDIR /app
RUN mkdir /app/public && mkdir /app/src
COPY other/package.json /app
COPY src/  /app/src
COPY public /app/public
ENV PATH /app/node_modules/.bin:$PATH
RUN npm install
RUN npm run build
FROM nginx:1.13.9-alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


