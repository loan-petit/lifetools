import { nexusPrismaPlugin } from 'nexus-prisma'
import { makeSchema } from 'nexus'
import path from 'path'
import * as types from './types'

export const schema = makeSchema({
  types,
  plugins: [nexusPrismaPlugin()],
  outputs: {
    schema: path.join(__dirname, '/generated/schema.graphql'),
    typegen: path.join(__dirname, '/generated/nexus.ts')
  },
  typegenAutoConfig: {
    sources: [
      {
        source: '@prisma/client',
        alias: 'client'
      },
      {
        source: require.resolve('./context'),
        alias: 'Context'
      }
    ],
    contextType: 'Context.Context'
  }
})
