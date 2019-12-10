import { queryType } from 'nexus'

export const DefaultQueries = queryType({
  definition (t) {
    t.crud.user()
    t.crud.users()

    t.crud.dailyRoutineEvent()
    t.crud.dailyRoutineEvents()

    t.crud.goal()
    t.crud.goals()
  }
})

export * from './User'
