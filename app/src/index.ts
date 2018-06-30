import {GraphQLServer} from 'graphql-yoga'
import {Prisma} from './gen/prisma'
import resolvers from './resolvers'

const server = new GraphQLServer({
    typeDefs: './src/schema.graphql',
    resolvers,
    resolverValidationOptions: {
        requireResolversForResolveType: false
    },
    context: req => ({
        ...req,
        db: new Prisma({
            endpoint: process.env.PRISMA_ENDPOINT, // the endpoint of the Prisma API (value set in `.env`)
            debug: process.env.DEBUG == 'true' // log all GraphQL queries & mutations sent to the Prisma API
            //secret: process.env.PRISMA_SECRET // only needed if specified in `database/prisma.yml` (value set in `.env`)
        })
    })
});

server
    .start()
    .then(server => console.log("Server running on port 4000"));