import { GraphQLServer } from 'graphql-yoga'
import { permissions } from './permissions'
import { schema } from './schema'
import { createContext } from './context'

new GraphQLServer({
  schema,
  context: createContext,
  middlewares: [permissions]
}).start(
  { playground: process.env.NODE_ENV === 'production' ? false : '/' },
  () => console.log('🚀 Server ready at: http://localhost:4000')
)
