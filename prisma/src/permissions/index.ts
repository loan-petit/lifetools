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
  isContentFeedbackOwner: rule()(async (parent, { id }, context) => {
    const userId = getUserId(context)
    const author = await context.photon.contentFeedbacks
      .findOne({
        where: {
          id
        }
      })
      .author()
    return userId === author.id
  }),
  isContentListOwner: rule()(async (parent, { id }, context) => {
    const userId = getUserId(context)
    const author = await context.photon.contentLists
      .findOne({
        where: {
          id
        }
      })
      .author()
    return userId === author.id
  })
}

export const permissions = shield({
  Query: {
    findOneUser: rules.isAuthenticatedUser,
    findManyUser: rules.isAuthenticatedUser,
    me: rules.isAuthenticatedUser
  },
  Mutation: {
    updateOneUser: rule.isCurrentUser,
    deleteOneUser: rule.isCurrentUser,

    createContent: rules.isAuthenticatedUser,

    createContentFeedback: rules.isAuthenticatedUser,
    updateOneContentFeedback: rules.isContentFeedbackOwner,
    deleteOneContentFeedback: rules.isContentFeedbackOwner,

    createContentList: rules.isAuthenticatedUser,
    followContentList: rules.isAuthenticatedUser,
    unfollowContentList: rules.isAuthenticatedUser,
    updateOneContentList: rules.isContentListOwner,
    deleteOneContentList: rules.isContentListOwner,

    followUser: rules.isAuthenticatedUser,
    unfollowUser: rules.isAuthenticatedUser
  }
})
