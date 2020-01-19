FROM node:alpine

ENV GLIBC_VERSION 2.30-r0

# Download and install glibc
RUN apk add --update curl && \
    curl -Lo /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    curl -Lo glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
    curl -Lo glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
    apk add glibc-bin.apk glibc.apk && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    apk del curl && \
    rm -rf glibc.apk glibc-bin.apk /var/cache/apk/*

# Install required dependencies
RUN apk add nodejs npm python g++ make && rm -rf /var/cache/apk/*

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

# Generate Photon and Nexus clients
RUN npm run generate

# Build API for production
RUN npm run build

# Start GraphQL API
CMD ["npm", "start"]
