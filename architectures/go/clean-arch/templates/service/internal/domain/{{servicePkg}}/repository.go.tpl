package {{servicePkg}}

import "context"

// Repository is declared by the CONSUMER, in the domain package. This is what
// keeps the dependency arrow pointing inward.
//
// This package must compile with only the standard library: no gin, no gorm,
// no database/sql.
type Repository interface {
	FindByID(ctx context.Context, id string) (*Entity, error)
	Save(ctx context.Context, e *Entity) error
	// noah:keep:start methods
	// noah:keep:end methods
}
