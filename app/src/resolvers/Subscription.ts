import { Context } from '../utils'

export const Subscription = {
  testSubscription: {
    subscribe: (parent, args, ctx: Context, info) => {
      return ctx.db.subscription.test({}, info);
    }
  }
};
