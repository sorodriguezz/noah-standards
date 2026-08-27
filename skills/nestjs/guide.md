This project uses **NestJS**.

## Commands

```bash
npm run start:dev
npm run test
npm run test:e2e
npx nest g module <name>
```

## Do

- Register providers by TOKEN when the consumer depends on an interface, so the
  implementation can be swapped in a test.
- Use `ConfigModule` with a validation schema; a missing env var should fail at
  boot, not at the first request that needs it.
- Put cross-cutting concerns in interceptors, guards and filters rather than
  repeating them in every controller.
- Use `useFactory` for anything needing async setup, and implement
  `OnModuleDestroy` for anything holding a connection.

## Don't

- Do not put business logic in a controller or in a module file.
- Do not use `forwardRef` to paper over a circular dependency; it is a signal the
  module boundary is wrong.
- Do not inject the request into a singleton provider — the scope leaks between
  requests.
