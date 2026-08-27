NOAH CONTEXT — {{serviceClass}} ({{archId}})

FILES
  {{srcRoot}}/modules/{{moduleName}}/application/{{serviceFile}}.service.ts
  {{srcRoot}}/modules/{{moduleName}}/domain/{{serviceFile}}.repository.ts

RULES YOU MUST FOLLOW
  1. {{serviceClass}} is in the APPLICATION layer. It MUST NOT import express,
     axios, node-fetch or @nestjs/platform-*.
     Reference: {{ruleDoc}} (Section 3.1)
  2. It depends on {{domainClass}}Repository by TOKEN. Never import the concrete
     repository class — that makes the use case untestable without a database.
     Reference: {{ruleDoc}} (Section 3.1)
  3. Create {{domainClass}} in domain/. It MUST NOT import @nestjs/*, typeorm,
     @prisma/client, axios or ioredis, and it must carry no decorators.
     Reference: {{ruleDoc}} (Section 4.1)
  4. Implement {{domainClass}}Repository under infrastructure/ and register it in
     the module with {{domainClass}}RepositoryToken.
     Reference: {{ruleDoc}} (Section 5.0)
{{#if pattern.redis-cache}}
  5. Caching is cache-aside behind CachePort. Every key gets an explicit TTL, and
     a cache failure MUST fall through to the repository, never surface as a 500.
     Reference: {{ruleDoc}} (Section 5.1)
{{/if}}

EDITING SAFELY
  Code between `// noah:keep:start <id>` and `// noah:keep:end <id>` survives
  regeneration. Everything else is overwritten.

VERIFY
  Run `noah inspect validate`.
