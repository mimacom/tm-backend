import {Context} from '../../interfaces/context';

export const Query = {

    me: (parent, args: null, ctx: Context, info) => {

        return {
            name: "test"
        };
        //return ctx.prisma.query.user({where: {id: ctx.user.id}}, info);
    }
};
