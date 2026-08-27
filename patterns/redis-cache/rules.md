## 5.1 Redis cache (cache-aside)

Caching is an optimisation that changes correctness. Every rule here exists
because ignoring it produces a bug that only appears under load.

- MUST use cache-aside: read through the cache, fall back to the source, then
  populate. Never write to the cache without also writing to the source of
  truth.
- MUST set an explicit TTL on every key. A key with no TTL is a memory leak with
  a slow fuse, and it will outlive the deploy that made it wrong.
- MUST namespace keys as `<app>:<entity>:<id>[:<version>]`. A flat keyspace makes
  targeted invalidation impossible and `FLUSHDB` the only tool left.
- MUST invalidate on write, in the same transaction boundary as the write.
  Deleting the key is safer than updating it: a failed update leaves a lie
  behind, a failed delete leaves a miss.
- MUST NOT cache anything the caller is authorised to see but another caller is
  not, unless the identity is part of the key.
- MUST treat every cache call as failure-tolerant. A Redis outage must degrade to
  the source of truth, never to a 500.
- SHOULD keep the cache behind a port declared by the domain, so the domain never
  imports a Redis client.
- SHOULD use jittered TTLs for keys populated together, or they all expire in the
  same second and stampede the database.
