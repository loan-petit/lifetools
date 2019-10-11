import { objectType } from 'nexus'

export const AuthPayload = objectType({
  name: 'AuthPayload',
  definition (t) {
    t.string('token')
    t.int('expiresIn')
    t.field('user', { type: 'User' })
  }
})
