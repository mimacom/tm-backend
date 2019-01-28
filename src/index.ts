import {GraphQLServerLambda} from 'graphql-yoga';
import {ContextParameters} from 'graphql-yoga/dist/types';

import {resolvers} from './resolvers';

const lambdaServer = new GraphQLServerLambda({
    typeDefs: './src/schema.graphql',
    resolvers,
    context: (params: ContextParameters) => ({
        ...params
    })
});

exports.playground = (event, context, callback) => {
    context.callbackWaitsForEmptyEventLoop = false;
    return lambdaServer.playgroundHandler(event, context, callback);
};

exports.server = (event, context, callback) => {
    context.callbackWaitsForEmptyEventLoop = false;
    return lambdaServer.graphqlHandler(event, context, callback);
};