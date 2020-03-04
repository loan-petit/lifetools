import { compare, hash } from 'bcryptjs'
import { sign } from 'jsonwebtoken'
import { mutationField, stringArg } from 'nexus'

import { JWT_SECRET } from '../../utils/getUserId'

export const signup = mutationField('signup', {
  type: 'AuthPayload',
  args: {
    username: stringArg({ nullable: false }),
    password: stringArg({ nullable: false }),
    passwordConfirmation: stringArg({ nullable: false })
  },
  resolve: async (
    _parent,
    { username, password, passwordConfirmation },
    ctx
  ) => {
    if (password !== passwordConfirmation) {
      throw new Error("'password' must match 'passwordConfirmation'")
    }

    const hashedPassword = await hash(password, 10)
    const user = await ctx.prisma.user.create({
      data: {
        username,
        password: hashedPassword
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

export const signin = mutationField('signin', {
  type: 'AuthPayload',
  args: {
    username: stringArg({ nullable: false }),
    password: stringArg({ nullable: false })
  },
  resolve: async (_parent, { username, password }, ctx) => {
    const user = await ctx.prisma.user.findOne({
      where: {
        username
      }
    })

    if (!user) {
      throw new Error(`No user found for username: ${username}`)
    }

    const passwordValid = await compare(password, user.password)
    if (!passwordValid) {
      throw new Error('Invalid password')
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
