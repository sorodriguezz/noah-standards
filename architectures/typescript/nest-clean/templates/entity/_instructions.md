NOAH CONTEXT — {{domainClass}} entity ({{archId}})

FILES
  {{srcRoot}}/modules/{{moduleName}}/domain/{{serviceFile}}.entity.ts

RULES YOU MUST FOLLOW
  1. DOMAIN layer. MUST NOT import @nestjs/*, typeorm, @prisma/client, axios,
     express or ioredis.
     Reference: {{ruleDoc}} (Section 4.1)
  2. No decorators. A decorator here means a framework reached into the middle of
     the hexagon.
     Reference: {{ruleDoc}} (Section 4.1)
  3. Enforce invariants in the constructor, so an invalid instance cannot exist.
  4. Prefer value objects over bare primitives for money, emails and identifiers.

VERIFY
  Run `noah inspect validate`.
