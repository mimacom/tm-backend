import {Prisma, User} from 'gen/prisma';
import {ContextParameters} from 'graphql-yoga/dist/types';

export interface Context extends ContextParameters {
    user: Partial<User>
    prisma: Prisma
}
