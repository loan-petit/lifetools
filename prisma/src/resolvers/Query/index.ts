import { queryType } from 'nexus'

import { me } from './User'

const DefaultQueries = queryType({
  definition (t) {
    t.crud.user()
    t.crud.users()

    t.crud.dailyroutineevent()
    t.crud.dailyroutineevents()

    t.crud.goal()
    t.crud.goals()
  }
})

export const Query = {
  DefaultQueries,
  me
}
