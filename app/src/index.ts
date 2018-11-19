import {GraphQLServer} from 'graphql-yoga';
import {Props, ContextParameters} from 'graphql-yoga/dist/types';

import {security} from '@security';
import {resolvers} from '@resolvers';
import {Prisma} from '@gen/prisma';
import jwt = require('express-jwt');

const prisma = new Prisma({
    endpoint: process.env.PRISMA_ENDPOINT,
    debug: process.env.PRISMA_DEBUG === 'true'
});

const server = new GraphQLServer({
    typeDefs: './src/schema.graphql',
    resolvers,
    resolverValidationOptions: {
        requireResolversForResolveType: false
    },
    middlewares: [
        security
    ],
    context: (params: ContextParameters) => ({
        ...params,
        user: params.request && params.request['user'],
        prisma
    })
} as Props);

server.express.use(jwt({secret: process.env.JWT_SECRET, credentialsRequired: false}));
server.start().then(_ => console.log("Server running on port 4000"));