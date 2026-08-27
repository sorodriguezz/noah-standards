NOAH CONTEXT — {{domainClass}}Controller ({{archId}})

FILES
  {{srcRoot}}/modules/{{moduleName}}/{{serviceFile}}.controller.ts

RULES YOU MUST FOLLOW
  1. CONTROLLER layer. MUST NOT import typeorm, @prisma/client, mongoose, pg,
     mysql2 or knex.
     Reference: {{ruleDoc}} (Section 2.1)
  2. Validate input with a DTO class and class-validator; return a response DTO,
     never a domain entity.
     Reference: {{ruleDoc}} (Section 2.1)
  3. No business logic. One use-case call per route handler.

VERIFY
  Run `noah inspect validate`.
