FROM node:latest

# Create Prisma Dir
RUN mkdir /prisma
WORKDIR /prisma

# Install dependencies before pushing the rest of the code in order to use
# cached dependencies when a file other than the package.json is changed in
# the current host directory
RUN mkdir ./prisma/
COPY ./package.json ./
COPY ./prisma/schema.prisma ./prisma/
COPY ./.prod.env ./.env
RUN npm install

# Copy code ressources
COPY . .

# Generate Photon and Nexus clients.
RUN npm run generate

# Start GraphQL API
CMD ["npm", "run", "dev"]
