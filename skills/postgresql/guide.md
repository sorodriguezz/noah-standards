This project uses **PostgreSQL** (`{{skill.postgresql.image}}`).

## Commands

```bash
docker compose up -d postgres
psql "$DATABASE_URL" -c '\dt'            # list tables
psql "$DATABASE_URL" -f script.sql
```

## Do

- Index every foreign key. Postgres does NOT create one automatically, and the
  missing index shows up as a slow cascade delete months later.
- Use `timestamptz`, never `timestamp`. The latter silently drops the offset.
- Use `text` rather than `varchar(n)` unless the limit is a real business rule;
  there is no performance difference and the constraint costs a migration.
- Wrap schema changes in a transaction. Postgres supports transactional DDL —
  most databases do not, and it makes a failed migration a non-event.
- Check `EXPLAIN (ANALYZE, BUFFERS)` before adding an index, not after.

## Don't

- Do not use `SELECT *` in application code; a new column changes the result
  shape under you.
- Do not add an index inside a normal migration on a large table: it takes an
  `ACCESS EXCLUSIVE` lock. Use `CREATE INDEX CONCURRENTLY` outside a transaction.
- Do not store money in `float`. Use `numeric`.
