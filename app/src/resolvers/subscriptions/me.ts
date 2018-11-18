import {Context} from 'interfaces/context';

export const Subscription = {
    me: {
        subscribe: (parent, args: null, ctx: Context, info) => {
            return ctx.prisma.subscription.user({
                where: {
                    mutation_in: ['UPDATED']
                }
            }, info)
        }
    }
};