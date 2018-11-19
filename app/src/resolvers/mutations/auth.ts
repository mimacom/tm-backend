import * as jwt from 'jsonwebtoken'
import * as bcrypt from 'bcryptjs'
import * as LdapAuth from 'ldapauth-fork-plus';

import {Context} from '@interfaces/context';

export const Mutation: any = {

    login: async (parent, {username, password}, ctx: Context) => {

        const user = await ctx.prisma.query.user({where: {username}});
        if (!user) {
            throw new Error(`No user found for specified username: ${username}`)
        }

        const valid = await bcrypt.compare(password, user.password);
        if (!valid) {
            throw new Error('Invalid password')
        }

        return {
            token: jwt.sign(user, process.env.JWT_SECRET),
            user
        }
    },

    loginLdap: async (parent, {username, password}, ctx: Context) => {

        return await new Promise((resolve, reject) => {

            const ldap = new LdapAuth({
                url: process.env.LDAP_URL,
                bindDN: process.env.LDAP_PRINCIPAL,
                bindCredentials: process.env.LDAP_PASSWORD,
                searchBase: process.env.LDAP_SEARCH_BASE,
                searchFilter: process.env.LDAP_SEARCH_FILTER,
                reconnect: false,
                tlsOptions: {
                    rejectUnauthorized: false
                },
                timeout: 3000,
                connectTimeout: 3000
            } as LdapAuth.Options);

            ldap.authenticate(username, password, async (error, ldapQueryUser) => {

                if (error) {
                    reject(error);
                    throw new Error('Failed to authenticate: ' + error);
                }

                const ldapUser: any = {
                    username: ldapQueryUser.sAMAccountName,
                    password: bcrypt.hashSync(password, 11),
                    email: ldapQueryUser.mail,
                    firstName: ldapQueryUser.givenName,
                    lastName: ldapQueryUser.sn,
                    title: ldapQueryUser.title,
                    location: ldapQueryUser.l,
                    countryCode: ldapQueryUser.c,
                    workPhone: ldapQueryUser.telephoneNumber,
                    workMobile: ldapQueryUser.homePhone,
                    mobile: ldapQueryUser.mobile
                };

                const dbUser = await ctx.prisma.query.user({where: {email: ldapUser.email}});

                let user;
                if (dbUser) {
                    user = await ctx.prisma.mutation.updateUser({data: ldapUser, where: {email: ldapUser.email}});
                } else {
                    user = await ctx.prisma.mutation.createUser({data: ldapUser});
                }

                resolve({
                    token: jwt.sign(user, process.env.JWT_SECRET),
                    user
                });
            });
        });
    }
};
