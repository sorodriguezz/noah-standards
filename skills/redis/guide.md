This project uses **Redis** (`{{skill.redis.image}}`).

## Commands

```bash
docker compose up -d redis
redis-cli PING
redis-cli --scan --pattern 'app:*' | head
redis-cli TTL <key>
```

## Do

- Set a TTL on every key you write. `EXPIRE` after `SET` is two round trips and a
  window where the key is immortal; use `SET key val EX 300`.
- Namespace keys as `<app>:<entity>:<id>`.
- Use `SCAN`, never `KEYS`, in anything that runs against a real instance:
  `KEYS` blocks the single-threaded server for the whole scan.
- Treat Redis as disposable. Anything that cannot be rebuilt from the source of
  truth does not belong here.

## Don't

- Do not use Redis as a primary datastore unless persistence is configured AND
  the durability guarantees have been checked against the requirement.
- Do not run `FLUSHALL` against a shared instance.
- Do not store large blobs; a multi-megabyte value stalls every other client.
