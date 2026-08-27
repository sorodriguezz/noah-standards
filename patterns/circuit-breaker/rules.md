## 5.2 Circuit breaker and outbound resilience

Every call that leaves the process can hang. Resilience is not an optional extra
around them; it is the definition of the call.

- MUST set a connect timeout and a read timeout on every outbound call. A call
  with no timeout inherits the worst behaviour of a system you do not control.
- MUST wrap outbound calls in a circuit breaker with an explicit failure
  threshold and a half-open probe. Retrying into a dead dependency converts one
  outage into two.
- MUST retry only IDEMPOTENT operations, with exponential backoff AND jitter.
  Retrying a payment without an idempotency key charges the customer twice;
  backoff without jitter synchronises every client into a thundering herd.
- MUST cap total attempts and total elapsed time. "Retry until it works" is a
  denial of service you wrote yourself.
- MUST define the fallback explicitly: cached value, empty result, or a typed
  error. An unhandled open breaker is just a 500 with extra steps.
- MUST NOT call an outbound service from the application layer directly. The call
  goes through an adapter that owns the timeout, breaker and fallback.
- SHOULD apply a bulkhead — a bounded concurrency limit per dependency — so one
  slow service cannot exhaust the whole thread or connection pool.
- SHOULD emit a metric on state transition. A breaker nobody can observe is a
  silent failure mode.
