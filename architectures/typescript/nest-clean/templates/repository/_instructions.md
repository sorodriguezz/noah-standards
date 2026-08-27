NOAH CONTEXT — {{domainClass}}PrismaRepository ({{archId}})

FILES
  {{srcRoot}}/modules/{{moduleName}}/infrastructure/{{serviceFile}}.prisma.repository.ts

RULES YOU MUST FOLLOW
  1. This implements {{domainClass}}Repository from domain/. The interface is
     owned by the domain, not by this file.
     Reference: {{ruleDoc}} (Section 5.0)
  2. Map the Prisma row to {{domainClass}} explicitly. Returning the row directly
     leaks the schema into the domain and makes a column rename a domain change.
     Reference: {{ruleDoc}} (Section 5.0)
  3. Register it in the module against {{domainClass}}RepositoryToken.

VERIFY
  Run `noah inspect validate`.
