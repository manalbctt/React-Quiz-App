# Use an official Node.js runtime as a parent image
FROM node:18 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React app
RUN npm run build

# Use an official Nginx image to serve the build folder
FROM nginx:alpine

# Copy the build folder from the previous image to Nginx's default html directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 to the host
EXPOSE 80

# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]
