import { compare, hash } from 'bcrypt'
import { sign } from 'jsonwebtoken'
import { mutationField, stringArg } from 'nexus'

import { JWT_SECRET } from '../../utils/getUserId'

export const signup = mutationField('signup', {
  type: 'AuthPayload',
  args: {
    email: stringArg(),
    password: stringArg(),
    passwordConfirmation: stringArg()
  },
  resolve: async (
    parent,
    { email, password, passwordConfirmation },
    ctx
  ) => {
    if (password !== passwordConfirmation) {
      throw new Error("'password' must match 'passwordConfirmation'")
    }
    const hashedPassword = await hash(password, 10)
    const user = await ctx.photon.users.create({
      data: {
        email,
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
    email: stringArg(),
    password: stringArg()
  },
  resolve: async (parent, { email, password }, ctx) => {
    const user = await ctx.photon.users.findOne({
      where: {
        email
      }
    })
    if (!user) {
      throw new Error(`No user found for email: ${email}`)
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