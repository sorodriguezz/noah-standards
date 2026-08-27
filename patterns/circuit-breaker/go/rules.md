### 5.2.3 Go specifics

- Use `github.com/sony/gobreaker`: one `*gobreaker.CircuitBreaker` per
  dependency, created at wiring time and shared.
- Set a timeout on the `http.Client` itself, not only on the context: a client
  with no timeout ignores a cancelled context during connection setup.
- `ReadyToTrip` should look at the failure RATIO over a window, not a raw count,
  or a low-traffic dependency trips on noise.
