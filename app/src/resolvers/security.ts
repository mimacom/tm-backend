import {rule, shield} from 'graphql-shield';

const isAuthenticated = rule()(async (parent, args, ctx, info) => {
    return ctx.user !== null;
});

const isOwner = rule()(async (parent, args, ctx, info) => {
    return ctx.user.id === '';
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
    },
    User: isAdmin
});

export {security};