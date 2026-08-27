### 5.1.1 TypeScript specifics

- Use `ioredis`, one shared client, created in a Nest provider with lifecycle
  hooks so it closes cleanly.
- Wrap `get`/`set` in a `CacheService` in `infrastructure/`; the use case depends
  on a `CachePort` interface declared in `domain/`.
- `JSON.parse` on cached data MUST be guarded: a schema change makes old entries
  unparseable, and an uncaught throw turns a cache hit into an outage.

```ts
const cached = await this.cache.get(key)
if (cached) return cached
const fresh = await this.repo.findById(id)
await this.cache.set(key, fresh, { ttlSeconds: 300 })
return fresh
```
