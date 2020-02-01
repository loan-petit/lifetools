import { rule, shield } from 'graphql-shield'
import { getUserId } from '../utils/getUserId'

const rules = {
  isAuthenticatedUser: rule()((_parent, _args, ctx) => {
    const userId = getUserId(ctx)
    return Boolean(userId)
  }),
  isCurrentUser: rule()(async (_parent, args, ctx) => {
    const userId = getUserId(ctx)
    const user = await ctx.prisma.user.findOne({
      where: {
        id: args.where.id
      }
    })
    return userId === user.id
  }),
  isDailyRoutineEventOwner: rule()(async (_parent, args, ctx) => {
    const userId = getUserId(ctx)
    const owner = await ctx.prisma.dailyRoutineEvent
      .findOne({
        where: {
          id: args.where.id
        }
      })
      .owner()
    return userId === owner.id
  }),
  isGoalOwner: rule()(async (_parent, args, ctx) => {
    const userId = getUserId(ctx)
    const owner = await ctx.prisma.goal
      .findOne({
        where: {
          id: args.where.id
        }
      })
      .owner()
    return userId === owner.id
  })
}

export const permissions = shield({
  Query: {
    user: rules.isAuthenticatedUser,
    users: rules.isAuthenticatedUser,
    me: rules.isAuthenticatedUser,

    dailyRoutineEvent: rules.isAuthenticatedUser,
    dailyRoutineEvents: rules.isAuthenticatedUser,

    goal: rules.isAuthenticatedUser,
    goals: rules.isAuthenticatedUser
  },
  Mutation: {
    updateOneUser: rules.isCurrentUser,
    deleteOneUser: rules.isCurrentUser,

    createOneDailyRoutineEvent: rules.isAuthenticatedUser,
    updateOneDailyRoutineEvent: rules.isDailyRoutineEventOwner,
    deleteOneDailyRoutineEvent: rules.isDailyRoutineEventOwner,

    createOneGoal: rules.isAuthenticatedUser,
    updateOneGoal: rules.isGoalOwner,
    deleteOneGoal: rules.isGoalOwner
  }
})
