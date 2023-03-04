# get the image for node from dockerhub
FROM node:14.20.0-alpine AS builder
# create working directory
WORKDIR /app
# copy the package.json
COPY package.json .
# copy the package-lock.json
COPY package-lock.json .
# install the depedancies
RUN npm install
# copy over the other files
COPY . .
# run the build
RUN npm run build

# step 2
# get the image for nginx from dockerhub
FROM nginx:stable-alpine
# Set the working directory
WORKDIR /usr/share/nginx/html
# Clear out the nginx statics
RUN rm -rf ./* 
# Copy built assets from builder
COPY --from=builder /app/build .
# documentation of the exposed port
EXPOSE 80
# command for runnning
CMD ["nginx", "-g", "daemon off;"]