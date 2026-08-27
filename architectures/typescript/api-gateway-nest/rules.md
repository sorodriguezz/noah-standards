## 2.2 Edge middleware

The gateway is the only place that knows about the outside world: who is
calling, how often, and from where.

- MUST NOT import domain or persistence code. A gateway that reaches into
  `/domain/` has turned into an application server.
- MUST apply, in this order: request id -> CORS -> rate limit -> authentication
  -> authorization -> body parsing. Parsing a body before rate limiting means an
  attacker sets the cost.
- MUST fail closed. An authentication middleware that throws must reject, never
  fall through.
- MUST set an explicit CORS allowlist. `origin: true` reflects any origin and
  defeats the check.
- SHOULD rate limit per identity when authenticated and per IP when not, and
  return `429` with `Retry-After`.
- SHOULD strip hop-by-hop and internal headers before proxying upstream.
