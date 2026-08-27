## 2.2 Aggregation layer

A BFF exists to serve ONE frontend. It aggregates upstream services and shapes
the response for that screen; it does not own business rules.

- MUST fan out to upstream services in parallel when the calls are independent.
  Sequential awaits over three services is three times the latency for no reason.
- MUST degrade partially: when a non-essential upstream fails, return the rest
  with the missing section marked, rather than failing the whole screen.
- MUST set an explicit timeout per upstream call. A BFF with no timeout inherits
  the worst latency of every service it touches.
- MUST NOT persist anything. A BFF with a database has stopped being a BFF.

## 2.3 View models

- MUST NOT import upstream client types or `@upstream/*`. Map upstream shapes
  into a view DTO explicitly, or an upstream refactor breaks the frontend.
- MUST be shaped for the screen that consumes it, not for the domain. Denormalise
  freely; that is the point.
- SHOULD carry only what the screen renders. Every extra field is payload the
  user pays for.

## 2.4 Tokens and identity

- MUST NOT forward the end-user token to an upstream service unchanged. Exchange
  it, or attach a service credential with the caller's identity as a claim.
- MUST NOT log tokens, even truncated.
