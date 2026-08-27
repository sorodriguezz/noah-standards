### 5.1.2 Java specifics

- Prefer Spring Cache abstractions (`@Cacheable`, `@CacheEvict`) over hand-rolled
  `RedisTemplate` calls, and configure TTL per cache name in
  `RedisCacheManagerBuilder` — the annotation alone has no expiry.
- `@Cacheable` on a method called from within the same class does NOT go through
  the proxy and silently does nothing. Call it across a bean boundary.
- Put the annotations on the outbound adapter, not on the use case: the
  application layer should not know its repository is cached.
- Set `spring.cache.redis.key-prefix` so two applications sharing one Redis do
  not collide.
