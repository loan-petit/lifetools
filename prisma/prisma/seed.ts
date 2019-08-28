import Photon from '@generated/photon'

const photon = new Photon()

async function main () {
  const fooUser = await photon.users.create({
    data: {
      email: 'foo@foo.com',
      password: '$2b$10$ZjONRZAxqX2pLoPax2xdcuzABTUEsFanQI6yBYCRtzpRiU4/X1uIu' // "graphql"
    }
  })
  console.log({ fooUser })
}

main().finally(async () => {
  await photon.disconnect()
})
