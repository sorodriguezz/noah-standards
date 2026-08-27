This project uses **Testcontainers**.

## Do

- Start ONE container per test class or suite, not per test method. Container
  startup dominates the runtime otherwise.
- Use a `@Container` static field (Java) or a module-scoped fixture, and let the
  library handle teardown via Ryuk.
- Wait on a real readiness signal — a log line or a successful query — not on a
  fixed sleep. A sleep is either flaky or slow, usually both.
- Pin the image tag so a base-image update cannot break CI overnight.

## Don't

- Do not point tests at a shared external database. The point is isolation.
- Do not reuse containers across suites unless `withReuse(true)` is deliberate
  and the state is reset between them.
