FROM node:7.0.0
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY package.json /usr/src/app/
RUN npm install
COPY . /usr/src/app
COPY ./docker/startup.sh /usr/src/app/
COPY ./docker/config.sh /usr/src/app/
EXPOSE 3000
#CMD [ "npm", "start" ]
CMD ["/usr/src/app/startup.sh"]