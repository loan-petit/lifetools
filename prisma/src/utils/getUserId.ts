import { verify } from 'jsonwebtoken'
import { Context } from '../context'

export const JWT_SECRET = (() => {
  if (process.env.NODE_ENV === 'production') {
    if (!process.env.JWT_SECRET) {
      throw Error('JWT_SECRET must be set in production.')
    }
    return process.env.JWT_SECRET
  }
  return 'prisma-secret'
})()

interface Token {
  userId: string
}

export function getUserId(context: Context) {
  const Authorization = context.request.get('Authorization')
  if (Authorization) {
    const token = Authorization.replace('Bearer ', '')
    const verifiedToken = verify(token, JWT_SECRET) as Token
    return verifiedToken && verifiedToken.userId
  }
}
