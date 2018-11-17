import {Query as me} from './queries/me'
import {Mutation as auth} from './mutations/auth'

const resolvers = {
    Query: {
        ...me
    },
    Mutation: {
        ...auth
    }
};

export {resolvers};
