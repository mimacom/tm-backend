import * as jwt from 'jsonwebtoken'
import {Request} from 'express';

export const getUserId = (request: Request) => {

    console.log("getUserId called");

    const authHeader = request.header('Authorization');

    console.log("Header: " + authHeader);

    if (authHeader && authHeader.startsWith('Bearer ')) {
        const token = authHeader.replace('Bearer ', '');
        const {userId} = jwt.verify(token, process.env.JWT_SECRET) as { userId: string };
        return userId;
    }
    return null;
};
