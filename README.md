# noah-standards

The official standards pack for [Noah](../noah-cli). Content only — no
executable code.

```
pack-manifest.json     the contract; see SCHEMA.md
architectures/         <language>/<id>/ : rules.md + templates/
patterns/              <id>/ : rules.md + <language>/rules.md
skills/                <id>/guide.md
ai-adapters/           <id>/header.tpl
templates/feature/     the SDD template
```

## What is in here

**Architectures**

| id | Language | Description |
|---|---|---|
| `nest-clean` | TypeScript | Clean architecture on NestJS |
| `bff-nest` | TypeScript | BFF, extends `nest-clean` |
| `api-gateway-nest` | TypeScript | API gateway, extends `nest-clean` |
| `spring-hexagonal` | Java | Ports and adapters on Spring Boot |
| `go-clean` | Go | Clean architecture with Gin |

**Patterns** — `redis-cache`, `circuit-breaker`, `cqrs`, each with
language-specific guidance for TypeScript, Java and Go.

**Skills** — `prisma`, `postgresql`, `redis`, `docker`, `nestjs`, `tailwind`,
`flyway`, `testcontainers`.

**Adapters** — `cursor`, `claude-code`, `windsurf`, `copilot`.

## Contributing

Read [SCHEMA.md](SCHEMA.md) first — it explains why several things that look
arbitrary are not, particularly the ban on filters in template paths and the
rule that section numbers are never renumbered.

Then validate before you commit:

```bash
npx @sorodriguezz/noah-cli pack validate . --strict
```

CI runs the same command plus the three acceptance criteria against fixture
projects, and asserts that generating twice leaves the tree unchanged.

### Adding a language

It is content, not code. Add a `languages[]` entry with its extensions, comment
syntax and import patterns, then an `architectures[]` entry with layers, rules
and a `templates/` directory. No change to the CLI is needed or accepted.
