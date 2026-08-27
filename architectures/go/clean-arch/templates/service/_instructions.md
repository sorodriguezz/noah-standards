NOAH CONTEXT — {{serviceType}} ({{archId}})

FILES
  internal/usecase/{{servicePkg}}/{{serviceFile}}.go
  internal/domain/{{servicePkg}}/repository.go

RULES YOU MUST FOLLOW
  1. {{serviceType}} is a USE CASE. It MUST NOT import github.com/gin-gonic/gin
     or net/http — a use case taking a *gin.Context cannot be called from a
     worker.
     Reference: {{ruleDoc}} (Section 3.1)
  2. Every method takes context.Context first and passes it down, so cancellation
     actually propagates.
     Reference: {{ruleDoc}} (Section 3.1)
  3. internal/domain/{{servicePkg}} MUST compile with only the standard library.
     No gin, no gorm.io/*, no database/sql, no Redis client.
     Reference: {{ruleDoc}} (Section 4.1)
  4. Return typed sentinel errors from the domain (var ErrNotFound = errors.New)
     so callers can branch without matching on strings.
  5. Wrap errors with fmt.Errorf("...: %w", err) to preserve the cause.

EDITING SAFELY
  Code between `// noah:keep:start <id>` and `// noah:keep:end <id>` survives
  regeneration.

VERIFY
  Run `noah inspect validate`.
