### 5.2.1 TypeScript specifics

- Use `cockatiel`: compose `retry`, `circuitBreaker` and `timeout` into ONE
  policy, built once per dependency and reused. Building a policy per call resets
  the breaker state on every request, which disables it entirely.

```ts
const policy = wrap(
  retry(handleAll, { maxAttempts: 3, backoff: new ExponentialBackoff() }),
  circuitBreaker(handleAll, { halfOpenAfter: 10_000, breaker: new ConsecutiveBreaker(5) }),
  timeout(2_000, TimeoutStrategy.Aggressive),
)
```
