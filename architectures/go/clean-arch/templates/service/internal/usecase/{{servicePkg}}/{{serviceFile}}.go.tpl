package {{servicePkg}}

import (
	"context"

	"{{moduleName}}/internal/domain/{{servicePkg}}"
)

// {{serviceType}} is the use case for {{servicePkg}}.
//
// It depends on the repository INTERFACE declared by the domain, takes a
// context.Context first, and must not import gin or net/http.
type {{serviceType}} struct {
	repo {{servicePkg}}.Repository
}

func New{{serviceType}}(repo {{servicePkg}}.Repository) *{{serviceType}} {
	return &{{serviceType}}{repo: repo}
}

// noah:keep:start methods
func (s *{{serviceType}}) FindByID(ctx context.Context, id string) (*{{servicePkg}}.Entity, error) {
	return s.repo.FindByID(ctx, id)
}
// noah:keep:end methods
