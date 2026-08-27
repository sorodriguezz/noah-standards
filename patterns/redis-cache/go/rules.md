### 5.1.3 Go specifics

- Use `github.com/redis/go-redis/v9`, one `*redis.Client` shared across the
  process and closed on shutdown.
- `redis.Nil` is a MISS, not an error. Treating it as one turns every cold key
  into a failed request.
- Always pass the request `context.Context`, or a cancelled request keeps waiting
  on Redis.

```go
val, err := c.rdb.Get(ctx, key).Result()
if errors.Is(err, redis.Nil) {
    // miss: load from the source of truth
} else if err != nil {
    // cache is down: log and fall through, do not fail the request
}
```
