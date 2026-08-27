Clean architecture in Go. Packages under `internal/` and dependencies pointing
inward; `domain` imports nothing from the project.

## 1.1 Layout

```
internal/
  domain/       entities and repository INTERFACES
  usecase/      application services
  handler/      gin handlers
  repository/   database implementations
```

## 2.1 Handlers

- MUST NOT import `database/sql`, `gorm.io/*`, `github.com/jackc/pgx` or
  `github.com/lib/pq`. Storage belongs in `repository/`.
- MUST bind and validate the request, call one use case, and map the result to a
  response struct.
- MUST map domain errors to status codes in one place, not with an `if err ==`
  ladder repeated in every handler.
- SHOULD pass `c.Request.Context()` down so cancellation actually propagates.

## 3.1 Use cases

- MUST NOT import `github.com/gin-gonic/gin` or `net/http`. A use case that
  takes a `*gin.Context` cannot be called from a worker.
- MUST accept `context.Context` as the first parameter.
- MUST depend on interfaces declared in `domain/`, defined by the CONSUMER.
- SHOULD wrap errors with `fmt.Errorf("...: %w", err)` so the cause survives.

## 4.1 Domain

- MUST NOT import `gin`, `gorm.io/*`, `database/sql`, `net/http` or a Redis
  client. This package must compile with only the standard library.
- MUST declare the repository interfaces the use cases need.
- SHOULD return typed sentinel errors (`var ErrNotFound = errors.New(...)`) so
  callers can branch without string matching.

## 5.0 Repositories

- MUST implement an interface from `domain/` and return domain types, never
  `sql.Rows` or a GORM model.
- MUST take `context.Context` and pass it to every query, or a cancelled request
  keeps holding a connection.
- SHOULD translate driver errors into the domain's sentinel errors.
