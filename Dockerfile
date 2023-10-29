FROM node as builder

WORKDIR /app

COPY src src/

COPY package.json tsconfig.json yarn.lock ./

RUN yarn install --frozen-lockfile && yarn build

# Use third-party, not official container image is not a good practice
# The right way is create a scratch-node container image to Liferay
FROM astefanutti/scratch-node

COPY --from=builder /app /

ENTRYPOINT ["node", "src/index.js"]
