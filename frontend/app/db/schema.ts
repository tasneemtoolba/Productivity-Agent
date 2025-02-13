import { integer, pgTable, varchar, timestamp } from "drizzle-orm/pg-core";

export const usersTable = pgTable("users", {
  id: integer().primaryKey().generatedAlwaysAsIdentity(),
  telegram: varchar({ length: 255 }).unique().notNull(),
  address: varchar({ length: 42 }).unique().notNull(),
  created: timestamp("created").defaultNow().notNull(),
  updated: timestamp("updated")
    .defaultNow()
    .$onUpdate(() => new Date()),
  deleted: timestamp("deleted"),
});
