import type { {{domainClass}} } from './{{serviceFile}}.entity'

/**
 * Repository PORT, declared by the domain and implemented in infrastructure/.
 * The token is what lets the application layer depend on this interface instead
 * of on a concrete class.
 */
export const {{domainClass}}RepositoryToken = Symbol('{{domainClass}}Repository')

export interface {{domainClass}}Repository {
  findById(id: string): Promise<{{domainClass}}>
  save(entity: {{domainClass}}): Promise<{{domainClass}}>
  // noah:keep:start methods
  // noah:keep:end methods
}
