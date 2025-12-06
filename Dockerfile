# --- Stage 1: Build the application ---
    FROM node:20-alpine as build-step

    WORKDIR /app

    # Install dependencies
    COPY package*.json ./
    RUN npm install

    # Copy the rest of the application code
    COPY . .

    # Build the application
    RUN npm run build

    # --- Stage 2: Serve the application with Nginx ---
        FROM nginx:alpine

        COPY nginx.conf /etc/nginx/conf.d/default.conf

        # Copy the built application from the previous stage to nginx's html directory
        COPY --from=build-step /app/dist/my-angular20-app/browser /usr/share/nginx/html

        # Expose port 80
        EXPOSE 80

        # Start Nginx server
        CMD ["nginx", "-g", "daemon off;"]