### 5.2.2 Java specifics

- Use Resilience4j. Order matters: `Retry(CircuitBreaker(TimeLimiter(call)))`.
  Wrapping the breaker inside the retry makes retries count against the breaker;
  wrapping it outside means the breaker never sees the failures at all.
- Configure per instance in `application.yml`. The default sliding window is
  rarely right for real traffic.
- `@CircuitBreaker(fallbackMethod = "...")` needs the fallback to share the
  signature plus a trailing `Throwable`, and it fails at RUNTIME when it does
  not.
