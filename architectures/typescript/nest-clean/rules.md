Clean architecture on NestJS. Modules group a feature; inside a module the
dependency arrow always points at the domain.

## 1.1 Layout

```
{{srcRoot}}/modules/<feature>/
  domain/            entities, value objects, repository INTERFACES
  application/       use cases
  infrastructure/    repository implementations, HTTP clients, cache
  <feature>.controller.ts
  <feature>.module.ts
```

## 2.1 Controllers

- MUST NOT import `typeorm`, `@prisma/client`, `mongoose`, `pg`, `mysql2` or
  `knex`. Persistence belongs in `infrastructure/`.
- MUST validate input with a DTO class and `class-validator`, and return a
  response DTO — never a domain entity.
- MUST NOT contain business logic. If a controller has an `if` that a product
  owner would have an opinion about, it is in the wrong file.
- SHOULD call exactly one use case per route handler.

## 3.1 Application layer

- MUST NOT import `express`, `axios`, `node-fetch` or `@nestjs/platform-*`.
- MUST depend on repository interfaces from `domain/`, injected by token. Import
  the concrete class and the use case becomes untestable without a database.
- MUST return domain objects or plain results; mapping to a response DTO is the
  controller's job.
- SHOULD be one exported class per use case, with a single `execute` method.

## 4.1 Domain

- MUST NOT import `@nestjs/*`, `typeorm`, `@prisma/client`, `axios`, `express`
  or `ioredis`. The domain has to be runnable in a plain unit test with no
  container and no I/O.
- MUST declare the repository interfaces the application layer depends on.
- SHOULD keep entities free of decorators. A decorator here means a framework
  reached into the middle of the hexagon.

## 5.0 Infrastructure

- MUST implement an interface declared in `domain/`.
- MUST be registered in the module with the token the domain declares, so the
  application layer never names a concrete class.
- SHOULD map ORM models to domain entities explicitly, in a dedicated mapper.
