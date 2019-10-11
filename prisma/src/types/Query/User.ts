import { queryField } from 'nexus'

import { sign } from 'jsonwebtoken'

import { JWT_SECRET, getUserId } from '../../utils/getUserId'

export const me = queryField('me', {
  type: 'AuthPayload',
  resolve: async (parent, args, ctx) => {
    const userId = getUserId(ctx)
    const user = await ctx.photon.users.findOne({
      where: {
        id: userId
      }
    })
    return {
      token: sign({ userId: user.id }, JWT_SECRET, {
        expiresIn: 86400 * 7
      }),
      expiresIn: 86400 * 7,
      user
    }
  }
})
