import {Query as meQuery} from './queries/me'
import {Mutation as authMutation} from './mutations/auth'
import {Subscription as meSubscription} from './subscriptions/me'

const resolvers = {
    Query: {
        ...meQuery
    },
    Mutation: {
        ...authMutation
    },
    Subscription: {
        ...meSubscription
    }
};

export {resolvers};
