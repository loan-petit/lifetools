import { queryType } from 'nexus'

import { me } from './User'

const DefaultQueries = queryType({
  definition (t) {
    t.crud.user()
    t.crud.users()

    t.crud.dailyroutineevent()
    t.crud.dailyroutineevents()
  }
})

export const Query = {
  DefaultQueries,
  me
}
