NOAH CONTEXT — {{domainName}}Controller ({{archId}})

FILES
  {{srcRoot}}/{{packagePath}}/adapter/in/web/{{domainName}}Controller.java

RULES YOU MUST FOLLOW
  1. This is the CONTROLLER layer. It MUST NOT import java.sql.*, javax.sql.*,
     org.hibernate.*, org.springframework.jdbc.* or jakarta.persistence.*.
     Reference: {{ruleDoc}} (Section 2.1)
  2. No business rules here. Shape validation on the request DTO is fine; any
     rule a product owner would have an opinion about belongs in the domain.
     Reference: {{ruleDoc}} (Section 2.1)
  3. Accept and return {{domainName}}Request / {{domainName}}Response records.
     Never serialise a domain entity or a JPA @Entity: it turns a column rename
     into a breaking API change.
  4. Delegate to {{serviceClass}}, one use case per endpoint.

VERIFY
  Run `noah inspect validate`.
