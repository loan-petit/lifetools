# Migration `20190830135556`

This migration has been generated at 8/30/2019, 1:55:56 PM.
You can check out the [state of the datamodel](./datamodel.prisma) after the migration.

## Database Steps

```sql
CREATE TABLE "public"."User"("id" text NOT NULL  ,"email" text NOT NULL DEFAULT '' ,"password" text NOT NULL DEFAULT '' ,PRIMARY KEY ("id"))
;

CREATE TABLE "public"."DailyRoutineItem"("id" text NOT NULL  ,"name" text NOT NULL DEFAULT '' ,"startTime" integer NOT NULL DEFAULT 0 ,"endTime" integer NOT NULL DEFAULT 0 ,PRIMARY KEY ("id"))
;

ALTER TABLE "public"."DailyRoutineItem" ADD COLUMN "owner" text   REFERENCES "public"."User"("id") ON DELETE SET NULL;

CREATE UNIQUE INDEX "DailyRoutineItem.id._UNIQUE" ON "public"."DailyRoutineItem"("id")
```

## Changes

```diff
diff --git datamodel.mdl datamodel.mdl
migration 20190830101944..20190830135556
--- datamodel.dml
+++ datamodel.dml
@@ -11,8 +11,17 @@
   provider = "nexus-prisma"
 }
 model User {
-  id                   String            @default(cuid()) @id @unique
-  email                String            @unique
-  password             String
+  id           String             @default(cuid()) @id @unique
+  email        String             @unique
+  password     String
+  dailyRoutine DailyRoutineItem[]
 }
+
+model DailyRoutineItem {
+  id        String @default(cuid()) @id @unique
+  name      String
+  startTime Int
+  endTime   Int
+  owner     User
+}
```

## Photon Usage

You can use a specific Photon built for this migration (20190830135556)
in your `before` or `after` migration script like this:

```ts
import Photon from '@generated/photon/20190830135556'

const photon = new Photon()

async function main() {
  const result = await photon.users()
  console.dir(result, { depth: null })
}

main()

```
