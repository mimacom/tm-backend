import * as bcrypt from 'bcryptjs'
import * as jwt from 'jsonwebtoken'
import {Context} from '../../utils'
import * as LdapAuth from 'ldapauth-fork-plus';

export const auth = {

    async login(parent, {username, password}, ctx: Context, info) {
        const user = await ctx.db.query.user({where: {username}});
        if (!user) {
            throw new Error(`No such user found for username: ${username}`)
        }

        const valid = await bcrypt.compare(password, user.password);
        if (!valid) {
            throw new Error('Invalid password')
        }

        return {
            token: jwt.sign({userId: user.id}, process.env.APP_SECRET),
            user
        }
    },

    async loginLdap(parent, {username, password}, ctx: Context, info) {

        const dbLookup = async (ldapUser: any) => {

            const dbUser = await ctx.db.query.user({where: {email: ldapUser.email}});

            let user;
            if (dbUser) {
                user = await ctx.db.mutation.updateUser({data: ldapUser, where: {email: ldapUser.email}});
            } else {
                user = await ctx.db.mutation.createUser({data: ldapUser});
            }
            return user;
        };

        return await new Promise((resolve, reject) => {

            const ldap = new LdapAuth({
                url: process.env.LDAP_URL,
                bindDN: process.env.LDAP_PRICIPAL,
                bindCredentials: process.env.LDAP_PASSWORD,
                searchBase: process.env.LDAP_SEARCH_BASE,
                searchFilter: process.env.LDAP_SEARCH_FILTER,
                reconnect: true
            });

            ldap.authenticate(username, password, (error, ldapQueryUser) => {

                if (error) {
                    throw new Error(`Auth failed: ${error}`);
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

                dbLookup(ldapUser).then(user =>  {
                    resolve({
                        token: jwt.sign({id: user.id}, process.env.APP_SECRET),
                        user
                    });
                });
            });
        });

    }
};
