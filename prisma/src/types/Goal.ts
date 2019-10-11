import { objectType } from 'nexus'

export const Goal = objectType({
  name: 'Goal',
  definition (t) {
    t.model.id()
    t.model.name()
    t.model.date()
    t.model.isCompleted()
    t.model.owner()
  }
})
