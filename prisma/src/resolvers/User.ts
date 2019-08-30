import { objectType } from '@prisma/nexus'

export const User = objectType({
  name: 'User',
  definition (t) {
    t.model.id()
    t.model.dailyRoutine()
  }
})
