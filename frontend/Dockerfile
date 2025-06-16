FROM  Node:20-alpine
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build
EXPOSE 3000
CMD ["npm", "server.js"]

# To run this Dockerfile, you can build it with:
# docker build -t my-node-app .