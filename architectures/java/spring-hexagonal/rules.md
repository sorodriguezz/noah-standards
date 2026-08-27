Ports and adapters. The domain sits in the middle and depends on nothing; every
technology touches it through an interface the domain itself declares.

## 1.1 Layout

```
{{srcRoot}}/{{packagePath}}/
  domain/          entities, value objects, domain services, PORT interfaces
  application/     use cases that orchestrate the domain
  adapter/in/      REST controllers, message listeners
  adapter/out/     JPA repositories, HTTP clients, cache
```

A dependency may only point INWARD: `adapter -> application -> domain`.
The domain declares the interface; the outbound adapter implements it.

## 2.1 Controllers

A controller translates HTTP into a use-case call and back. Nothing else.

- MUST NOT import `java.sql.*`, `jakarta.persistence.*`, `org.hibernate.*` or
  `org.springframework.jdbc.*`. Persistence belongs behind an outbound port.
- MUST NOT contain business rules, including validation that expresses a domain
  invariant. Shape validation on the request DTO is fine; "an order over 10.000
  needs approval" is not.
- MUST accept and return its own request/response records, never a domain entity
  and never a JPA `@Entity`. Serialising an entity leaks the schema into the API
  contract and turns a column rename into a breaking change.
- SHOULD delegate to exactly one use case per endpoint.

## 3.1 Application layer

- MUST NOT import `org.springframework.web.*` or `jakarta.servlet.*`. A use case
  that knows about HTTP cannot be driven from a test, a queue or a scheduler.
- MUST depend on port INTERFACES, never on an adapter implementation.
- MUST own the transaction boundary. `@Transactional` belongs here, not on a
  controller and not on a repository.
- SHOULD be one class per use case, with a single public method.

## 4.1 Domain

- MUST NOT import `org.springframework.*`, `jakarta.persistence.*` or
  `com.fasterxml.jackson.*`. A domain that needs a container to run is not a
  domain, it is a framework plugin.
- MUST express invariants in constructors and factory methods, so an invalid
  instance cannot be created.
- SHOULD prefer value objects over primitives: `Money`, `EmailAddress`,
  `OrderId`. A method taking four `String`s is a bug waiting for an argument
  swap.

## 5.0 Outbound adapters

- MUST implement a port interface declared in `domain/`.
- MUST map between the persistence model and the domain model explicitly. A JPA
  entity is not a domain entity; sharing one class couples the schema to the
  business rules in both directions.
- SHOULD keep transaction annotations out; the application layer owns them.
