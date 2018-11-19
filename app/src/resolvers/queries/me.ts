import {Context} from '@interfaces/context';

export const Query = {

    me: async (parent, args: null, ctx: Context, info) => {
        return ctx.prisma.query.user({where: {id: ctx.user.id}}, info);
    }
};
