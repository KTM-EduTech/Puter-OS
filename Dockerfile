FROM node:21-alpine

# Set labels
LABEL repo="https://github.com/HeyPuter/puter"
LABEL license="AGPL-3.0,https://github.com/HeyPuter/puter/blob/master/LICENSE.txt"
LABEL version="1.2.46-beta-1"

# Install git (required by Puter to check version)
# python3 would be required by node-gyp to natively build node addon 
# This is required if we build for multi-platform
RUN apk add --no-cache git python3 make g++ \
    && ln -sf /usr/bin/python3 /usr/bin/python
    
# Setup working directory
RUN mkdir -p /opt/puter/app
WORKDIR /opt/puter/app

# Add source files
# NOTE: This might change (https://github.com/HeyPuter/puter/discussions/32)
COPY . .

# Set permissions
RUN chown -R node:node /opt/puter/app
USER node

# Install node modules
RUN npm cache clean --force \
    && npm install

EXPOSE 4100

HEALTHCHECK  --interval=30s --timeout=3s \
  CMD wget --no-verbose --tries=1 --spider http://puter.localhost:4100/test || exit 1

CMD [ "npm", "start" ]
