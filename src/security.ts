import {rule, shield} from 'graphql-shield';
import {Context} from './interfaces/context';

const isAuthenticated = rule()(async (parent, args, ctx: Context, info) => {
    return ctx.user !== null;
});

const isAdmin = rule()(async (parent, args, ctx, info) => {
    return ctx.user.role === 'ADMIN';
});

const isManager = rule()(async (parent, args, ctx, info) => {
    return ctx.user.role === 'MANAGER';
});

const security = shield({
    Query: {
        me: isAuthenticated
    }
});

export {security};