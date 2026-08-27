NOAH CONTEXT — {{serviceClass}} ({{archId}})

You are editing a Spring Boot hexagonal codebase. These rules are binding for the
files just generated. The full rule set is in {{ruleDoc}}.

FILES
  {{srcRoot}}/{{packagePath}}/application/{{serviceClass}}.java   application service
  {{srcRoot}}/{{packagePath}}/domain/port/{{domainName}}Repository.java   outbound port

RULES YOU MUST FOLLOW
  1. {{serviceClass}} lives in the APPLICATION layer. It MUST NOT import
     org.springframework.web.*, jakarta.servlet.* or any HTTP type.
     Reference: {{ruleDoc}} (Section 3.1)
  2. {{serviceClass}} MUST depend on {{domainName}}Repository, the PORT interface
     in domain/port. Never import a class from adapter/out.
     Reference: {{ruleDoc}} (Section 3.1)
  3. The transaction boundary belongs HERE. Put @Transactional on this class's
     methods, not on the controller and not on the repository adapter.
  4. {{domainName}} in domain/ MUST NOT import org.springframework.*,
     jakarta.persistence.* or com.fasterxml.jackson.*. Create it as a plain
     Java class whose constructor enforces its invariants.
     Reference: {{ruleDoc}} (Section 4.1)
  5. Implement {{domainName}}Repository under adapter/out/persistence, and map
     between the JPA entity and {{domainName}} explicitly. Do not annotate the
     domain class with @Entity.
     Reference: {{ruleDoc}} (Section 5.0)

EDITING SAFELY
  Code between `// noah:keep:start <id>` and `// noah:keep:end <id>` is yours and
  survives regeneration. Anything outside those markers is overwritten the next
  time this generator runs.

VERIFY
  Run `noah inspect validate` after your changes. It exits 1 and prints the exact
  rule reference for any import that breaks the architecture.
