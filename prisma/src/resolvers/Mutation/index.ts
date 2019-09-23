import { mutationType } from 'nexus'

import { signup, signin } from './User'

const DefaultMutations = mutationType({
  definition (t) {
    t.crud.updateOneUser()
    t.crud.deleteOneUser()

    t.crud.createOneDailyRoutineEvent()
    t.crud.updateOneDailyRoutineEvent()
    t.crud.deleteOneDailyRoutineEvent()

    t.crud.createOneGoal()
    t.crud.updateOneGoal()
    t.crud.deleteOneGoal()
  }
})

export const Mutation = {
  DefaultMutations,
  signup,
  signin,
}
