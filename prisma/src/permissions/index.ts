import { rule, shield } from 'graphql-shield'
import { getUserId } from '../utils/getUserId'

const rules = {
  isAuthenticatedUser: rule()((parent, args, context) => {
    const userId = getUserId(context)
    return Boolean(userId)
  }),
  isCurrentUser: rule()(async (parent, { id }, context) => {
    const userId = getUserId(context)
    const user = await context.photon.users.findOne({
      where: {
        id
      }
    })
    return userId === user.id
  }),
  isDailyRoutineItemOwner: rule()(async (parent, { id }, context) => {
    const userId = getUserId(context)
    const owner = await context.photon.dailyRoutineItems
      .findOne({
        where: {
          id
        }
      })
      .owner()
    return userId === owner.id
  }),
}

export const permissions = shield({
  Query: {
    findOneUser: rules.isAuthenticatedUser,
    findManyUser: rules.isAuthenticatedUser,
    me: rules.isAuthenticatedUser,

    findOneDailyRoutineItem: rules.isAuthenticatedUser,
    findManyDailyRoutineItem: rules.isAuthenticatedUser,
  },
  Mutation: {
    updateOneUser: rules.isCurrentUser,
    deleteOneUser: rules.isCurrentUser,

    createOneDailyRoutineItem: rules.isAuthenticatedUser,
    updateOneDailyRoutineItem: rules.isDailyRoutineItemOwner,
    deleteOneDailyRoutineItem: rules.isDailyRoutineItemOwner,
  }
})
