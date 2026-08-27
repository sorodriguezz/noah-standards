NOAH CONTEXT — {{domainClass}}Module ({{archId}})

FILES
  {{srcRoot}}/modules/{{moduleName}}/{{moduleName}}.module.ts

RULES YOU MUST FOLLOW
  1. Bind every port token to its implementation here. The application layer must
     never name a concrete class.
     Reference: {{ruleDoc}} (Section 5.0)
  2. Export only what another module legitimately needs. Exporting a repository
     lets a different module bypass this one's use cases.
  3. No business logic in a module file.

VERIFY
  Run `noah inspect validate`.
