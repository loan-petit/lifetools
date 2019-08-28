# Migration `20190830101944`

This migration has been generated at 8/30/2019, 10:19:44 AM.
You can check out the [state of the datamodel](./datamodel.prisma) after the migration.

## Database Steps

```sql
CREATE TABLE "public"."User"("id" text NOT NULL  ,"email" text NOT NULL DEFAULT '' ,"password" text NOT NULL DEFAULT '' ,PRIMARY KEY ("id"))
;

CREATE UNIQUE INDEX "User.id._UNIQUE" ON "public"."User"("id")

CREATE UNIQUE INDEX "User.email._UNIQUE" ON "public"."User"("email")
```

## Changes

```diff
diff --git datamodel.mdl datamodel.mdl
migration ..20190830101944
--- datamodel.dml
+++ datamodel.dml
@@ -1,0 +1,18 @@
+datasource db {
+  provider = "postgresql"
+  url      = env("POSTGRES_URL")
+}
+
+generator photonjs {
+  provider = "photonjs"
+}
+
+generator nexus_prisma {
+  provider = "nexus-prisma"
+}
+
+model User {
+  id                   String            @default(cuid()) @id @unique
+  email                String            @unique
+  password             String
+}
```

## Photon Usage

You can use a specific Photon built for this migration (20190830101944)
in your `before` or `after` migration script like this:

```ts
import Photon from '@generated/photon/20190830101944'

const photon = new Photon()

async function main() {
  const result = await photon.users()
  console.dir(result, { depth: null })
}

main()

```
