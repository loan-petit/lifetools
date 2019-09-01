import { rule, shield } from 'graphql-shield'
import { getUserId } from '../utils/getUserId'

const rules = {
  isAuthenticatedUser: rule()((parent, args, context) => {
    const userId = getUserId(context)
    
    return Boolean(userId)
  }),
  isCurrentUser: rule()(async (parent, args, context) => {
    const userId = getUserId(context)
    const user = await context.photon.users.findOne({
      where: {
        id: args.where.id
      }
    })
    return userId === user.id
  }),
  isDailyRoutineEventOwner: rule()(async (parent, args, context) => {
    const userId = getUserId(context)
    const owner = await context.photon.dailyRoutineEvents
      .findOne({
        where: {
          id: args.where.id
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

    findOneDailyRoutineEvent: rules.isAuthenticatedUser,
    findManyDailyRoutineEvent: rules.isAuthenticatedUser,
  },
  Mutation: {
    updateOneUser: rules.isCurrentUser,
    deleteOneUser: rules.isCurrentUser,

    createOneDailyRoutineEvent: rules.isAuthenticatedUser,
    updateOneDailyRoutineEvent: rules.isDailyRoutineEventOwner,
    deleteOneDailyRoutineEvent: rules.isDailyRoutineEventOwner,
  }
})
