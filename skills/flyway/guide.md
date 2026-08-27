This project uses **Flyway** for database migrations.

## Commands

```bash
./mvnw flyway:migrate
./mvnw flyway:info
./mvnw flyway:validate
```

## Do

- Name migrations `V<version>__<description>.sql` in
  `src/main/resources/db/migration`. The double underscore is required.
- Treat an applied migration as immutable. Flyway checksums them, and editing one
  makes `validate` fail for everyone.
- Use `R__` repeatable migrations for views and functions, which can be replaced
  safely.
- Run `flyway:validate` in CI so a checksum mismatch is caught before deploy.

## Don't

- Do not use `flyway:clean` outside a throwaway local database; it drops the
  schema.
- Do not mix DDL and long-running data backfills in one migration: the lock is
  held for the whole thing.
