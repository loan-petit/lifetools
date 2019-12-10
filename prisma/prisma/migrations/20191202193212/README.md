# Migration `20191202193212`

This migration has been generated at 12/2/2019, 7:32:12 PM.
You can check out the [state of the schema](./schema.prisma) after the migration.

## Database Steps

```sql
CREATE TABLE "public"."User" (
  "createdAt" timestamp(3) NOT NULL DEFAULT '1970-01-01 00:00:00' ,
  "email" text NOT NULL DEFAULT '' ,
  "id" text NOT NULL  ,
  "password" text NOT NULL DEFAULT '' ,
  PRIMARY KEY ("id")
);

CREATE TABLE "public"."DailyRoutineEvent" (
  "endTime" integer NOT NULL DEFAULT 0 ,
  "id" text NOT NULL  ,
  "name" text NOT NULL DEFAULT '' ,
  "startTime" integer NOT NULL DEFAULT 0 ,
  PRIMARY KEY ("id")
);

CREATE TABLE "public"."Goal" (
  "date" timestamp(3) NOT NULL DEFAULT '1970-01-01 00:00:00' ,
  "id" text NOT NULL  ,
  "isCompleted" boolean NOT NULL DEFAULT false ,
  "name" text NOT NULL DEFAULT '' ,
  PRIMARY KEY ("id")
);

ALTER TABLE "public"."DailyRoutineEvent" ADD COLUMN "owner" text NOT NULL  REFERENCES "public"."User"("id") ON DELETE RESTRICT;

ALTER TABLE "public"."Goal" ADD COLUMN "owner" text NOT NULL  REFERENCES "public"."User"("id") ON DELETE RESTRICT;

CREATE UNIQUE INDEX "User.id" ON "public"."User"("id")

CREATE UNIQUE INDEX "User.email" ON "public"."User"("email")

CREATE UNIQUE INDEX "DailyRoutineEvent.id" ON "public"."DailyRoutineEvent"("id")

CREATE UNIQUE INDEX "Goal.id" ON "public"."Goal"("id")
```

## Changes

```diff
diff --git datamodel.mdl datamodel.mdl
migration ..20191202193212
--- datamodel.dml
+++ datamodel.dml
@@ -1,0 +1,34 @@
+datasource db {
+  provider = "postgresql"
+  url      = env("POSTGRES_URL")
+  default  = true
+}
+
+generator photonjs {
+  provider = "photonjs"
+}
+
+model User {
+  id           String              @default(cuid()) @id @unique
+  createdAt    DateTime            @default(now())
+  email        String              @unique
+  password     String
+  dailyRoutine DailyRoutineEvent[]
+  goals        Goal[]
+}
+
+model DailyRoutineEvent {
+  id        String @default(cuid()) @id @unique
+  name      String
+  startTime Int
+  endTime   Int
+  owner     User
+}
+
+model Goal {
+  id          String   @default(cuid()) @id @unique
+  name        String
+  date        DateTime
+  isCompleted Boolean  @default(false)
+  owner       User
+}
```

## Photon Usage

You can use a specific Photon built for this migration (20191202193212)
in your `before` or `after` migration script like this:

```ts
import Photon from '@generated/photon/20191202193212'

const photon = new Photon()

async function main() {
  const result = await photon.users()
  console.dir(result, { depth: null })
}

main()

```