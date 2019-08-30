import { mutationType } from 'nexus'

import { signup, signin } from './User'

const DefaultMutations = mutationType({
  definition (t) {
    t.crud.updateOneUser()
    t.crud.deleteOneUser()

    t.crud.createOneDailyRoutineItem()
    t.crud.updateOneDailyRoutineItem()
    t.crud.deleteOneDailyRoutineItem()
  }
})

export const Mutation = {
  DefaultMutations,
  signup,
  signin,
}
