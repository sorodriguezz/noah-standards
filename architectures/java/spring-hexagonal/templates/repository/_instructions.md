NOAH CONTEXT — {{domainName}}PersistenceAdapter ({{archId}})

FILES
  {{srcRoot}}/{{packagePath}}/adapter/out/persistence/{{domainName}}PersistenceAdapter.java

RULES YOU MUST FOLLOW
  1. This class implements {{domainName}}Repository, the port declared in
     domain/port. The interface belongs to the domain, not to this adapter.
     Reference: {{ruleDoc}} (Section 5.0)
  2. Map between the JPA entity and {{domainName}} explicitly. Do NOT annotate
     the domain class with @Entity — sharing one class couples the database
     schema to the business rules in both directions.
     Reference: {{ruleDoc}} (Section 5.0)
  3. Do not put @Transactional here. The application layer owns the boundary.
  4. You still need {{domainName}}JpaEntity, {{domainName}}JpaRepository and
     {{domainName}}Mapper in this package.

VERIFY
  Run `noah inspect validate`.
