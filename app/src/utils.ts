import * as jwt from 'jsonwebtoken'
import {Prisma} from './gen/prisma'

export interface Context {
    db: Prisma
    request: any
}

export function getUserId(ctx: Context) {
    const Authorization = ctx.request.get('Authorization');
    if (Authorization) {
        const token = Authorization.replace('Bearer ', '');
        const {userId} = jwt.verify(token, process.env.JWT_SECRET) as { userId: string };
        return userId;
    }

    throw new AuthError();
}

export class AuthError extends Error {

    constructor() {
        super('Forbidden')
    }
}
