import { objectType } from '@prisma/nexus'

export const DailyRoutineItem = objectType({
  name: 'DailyRoutineItem',
  definition (t) {
    t.model.id()
    t.model.name()
    t.model.startTime()
    t.model.endTime()
    t.model.owner()
  }
})
