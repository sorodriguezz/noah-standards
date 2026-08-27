### 5.3.1 TypeScript specifics

- `@nestjs/cqrs`: one class per command or query, one `@CommandHandler` /
  `@QueryHandler` per class, registered in the module's `providers`.
- An unregistered handler fails at RUNTIME with "no handler found", never at
  compile time. Register it in the same commit that adds it.
- Keep `commands/`, `queries/` and `handlers/` as sibling directories inside the
  module, so the asymmetry is visible in the tree.
