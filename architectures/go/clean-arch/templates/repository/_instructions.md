NOAH CONTEXT — {{servicePkg}} PostgresRepository ({{archId}})

FILES
  internal/repository/{{servicePkg}}/postgres.go

RULES YOU MUST FOLLOW
  1. This implements domain.Repository and MUST return domain types. Returning
     *sql.Rows or a GORM model leaks storage into the use case.
     Reference: {{ruleDoc}} (Section 5.0)
  2. Every query takes ctx and passes it, or a cancelled request keeps holding a
     connection.
     Reference: {{ruleDoc}} (Section 5.0)
  3. Translate driver errors into the domain's sentinel errors: sql.ErrNoRows
     becomes domain.ErrNotFound, never leaks upward as-is.
  4. The handler layer MUST NOT import database/sql. That is why this file exists.
     Reference: {{ruleDoc}} (Section 2.1)

VERIFY
  Run `noah inspect validate`.
