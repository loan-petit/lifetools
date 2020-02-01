import { queryField } from 'nexus'

import { sign } from 'jsonwebtoken'

import { JWT_SECRET, getUserId } from '../../utils/getUserId'

export const me = queryField('me', {
  type: 'AuthPayload',
  resolve: async (_parent, _args, ctx) => {
    const userId = getUserId(ctx)
    const user = await ctx.prisma.user.findOne({
      where: {
        id: userId
      }
    })

    if (!user) {
      throw new Error('No user match this JWT.')
    }

    return {
      token: sign({ userId: user.id }, JWT_SECRET, {
        expiresIn: 86400 * 7
      }),
      expiresIn: 86400 * 7,
      user
    }
  }
})
