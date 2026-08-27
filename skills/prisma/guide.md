This project uses **Prisma** ({{skill.prisma.provider}}).

## Commands

```bash
npx prisma migrate dev --name <change>   # create + apply a migration in dev
npx prisma migrate deploy                # apply pending migrations (CI/prod)
npx prisma generate                      # regenerate the client after a schema edit
npx prisma studio                        # browse the data
```

## Do

- Edit `prisma/schema.prisma`, then run `migrate dev`. The migration is the
  artefact; the schema file alone changes nothing in the database.
- Run `prisma generate` after every schema change, or the client's types silently
  describe the previous schema.
- Use `select` to fetch only the fields you need. The default returns every
  column, including ones added later by someone else.
- Use `$transaction` for multi-write operations that must not partially apply.

## Don't

- Never run `migrate dev` against production; it can reset the database. Use
  `migrate deploy`.
- Never edit a migration that has already been applied anywhere. Write a new one.
- Do not call `$queryRawUnsafe` with interpolated input. Use `$queryRaw` with a
  tagged template, which parameterises.
- Do not import `@prisma/client` outside the infrastructure layer.
