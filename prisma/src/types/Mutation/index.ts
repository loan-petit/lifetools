import { mutationType } from 'nexus'

export const DefaultMutations = mutationType({
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

export * from './User'