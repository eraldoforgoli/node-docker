# Specify parent directory
FROM node:8

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies 
# A wildcard to copy both  package.json and package-lock.jason
COPY package*.json ./

RUN npm install

# Install express
RUN npm install express

# Bundle app source
COPY . . 

EXPOSE 8000

CMD ["npm", "start"]
