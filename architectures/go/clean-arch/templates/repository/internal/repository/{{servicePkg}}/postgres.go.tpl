package {{servicePkg}}

import (
	"context"
	"database/sql"
	"errors"
	"fmt"

	domain "{{moduleName}}/internal/domain/{{servicePkg}}"
)

// PostgresRepository implements domain.Repository.
//
// It returns DOMAIN types, never *sql.Rows, and translates driver errors into
// the domain's sentinel errors.
type PostgresRepository struct {
	db *sql.DB
}

func NewPostgresRepository(db *sql.DB) *PostgresRepository {
	return &PostgresRepository{db: db}
}

func (r *PostgresRepository) FindByID(ctx context.Context, id string) (*domain.Entity, error) {
	// noah:keep:start findById
	row := r.db.QueryRowContext(ctx, `SELECT id FROM {{servicePkg}} WHERE id = $1`, id)
	var e domain.Entity
	if err := row.Scan(&e.ID); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, domain.ErrNotFound
		}
		return nil, fmt.Errorf("find {{servicePkg}} by id: %w", err)
	}
	return &e, nil
	// noah:keep:end findById
}

func (r *PostgresRepository) Save(ctx context.Context, e *domain.Entity) error {
	// noah:keep:start save
	_, err := r.db.ExecContext(ctx, `INSERT INTO {{servicePkg}} (id) VALUES ($1)
		ON CONFLICT (id) DO UPDATE SET id = EXCLUDED.id`, e.ID)
	if err != nil {
		return fmt.Errorf("save {{servicePkg}}: %w", err)
	}
	return nil
	// noah:keep:end save
}
