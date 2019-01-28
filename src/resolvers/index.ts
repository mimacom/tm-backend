import {Query as meQuery} from './queries/me'
import {Mutation as authMutation} from './mutations/auth'

const resolvers = {
    Query: {
        ...meQuery
    },
    Mutation: {
        ...authMutation
    }/*,
    Subscription: {
        ...meSubscription
    }*/
};

export {resolvers};
