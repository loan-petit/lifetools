import { queryType } from 'nexus'

import { me } from './User'

const DefaultQueries = queryType({
  definition (t) {
    t.crud.findOneUser()
    t.crud.findManyUser()

    t.crud.findOneDailyRoutineEvent()
    t.crud.findManyDailyRoutineEvent()
  }
})

export const Query = {
  DefaultQueries,
  me
}
