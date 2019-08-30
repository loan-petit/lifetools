# Migration `20190830194736`

This migration has been generated at 8/30/2019, 7:47:36 PM.
You can check out the [state of the datamodel](./datamodel.prisma) after the migration.

## Database Steps

```sql
CREATE TABLE "public"."User"("id" text NOT NULL  ,"email" text NOT NULL DEFAULT '' ,"password" text NOT NULL DEFAULT '' ,PRIMARY KEY ("id"))
;

CREATE TABLE "public"."DailyRoutineEvent"("id" text NOT NULL  ,"name" text NOT NULL DEFAULT '' ,"startTime" integer NOT NULL DEFAULT 0 ,"endTime" integer NOT NULL DEFAULT 0 ,PRIMARY KEY ("id"))
;

ALTER TABLE "public"."DailyRoutineEvent" ADD COLUMN "owner" text   REFERENCES "public"."User"("id") ON DELETE SET NULL;

CREATE UNIQUE INDEX "User.id._UNIQUE" ON "public"."User"("id")

CREATE UNIQUE INDEX "User.email._UNIQUE" ON "public"."User"("email")

CREATE UNIQUE INDEX "DailyRoutineEvent.id._UNIQUE" ON "public"."DailyRoutineEvent"("id")
```

## Changes

```diff
diff --git datamodel.mdl datamodel.mdl
migration ..20190830194736
--- datamodel.dml
+++ datamodel.dml
@@ -1,0 +1,27 @@
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
+  id           String             @default(cuid()) @id @unique
+  email        String             @unique
+  password     String
+  dailyRoutine DailyRoutineEvent[]
+}
+
+model DailyRoutineEvent {
+  id        String @default(cuid()) @id @unique
+  name      String
+  startTime Int
+  endTime   Int
+  owner     User
+}
```

## Photon Usage

You can use a specific Photon built for this migration (20190830194736)
in your `before` or `after` migration script like this:

```ts
import Photon from '@generated/photon/20190830194736'

const photon = new Photon()

async function main() {
  const result = await photon.users()
  console.dir(result, { depth: null })
}

main()

```
