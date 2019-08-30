import { objectType } from '@prisma/nexus'

export const DailyRoutineEvent = objectType({
  name: 'DailyRoutineEvent',
  definition (t) {
    t.model.id()
    t.model.name()
    t.model.startTime()
    t.model.endTime()
    t.model.owner()
  }
})
