import { Inject, Injectable } from '@nestjs/common'
import { {{domainClass}}Repository, {{domainClass}}RepositoryToken } from '../domain/{{serviceFile}}.repository'
{{#if pattern.redis-cache}}
import { CachePort, CachePortToken } from '../domain/cache.port'
{{/if}}

/**
 * Application service for {{domainClass}}.
 *
 * Depends on the repository INTERFACE by token, so it can be unit-tested with no
 * database. It must not import express, axios or any @nestjs/platform package.
 */
@Injectable()
export class {{serviceClass}} {
  constructor(
    @Inject({{domainClass}}RepositoryToken)
    private readonly repository: {{domainClass}}Repository,
{{#if pattern.redis-cache}}
    @Inject(CachePortToken)
    private readonly cache: CachePort,
{{/if}}
  ) {}

  // noah:keep:start methods
  async findById(id: string): Promise<{{domainClass}}> {
{{#if pattern.redis-cache}}
    const key = `{{projectName}}:{{serviceFile}}:${id}`
    const cached = await this.cache.get<{{domainClass}}>(key)
    if (cached) return cached
    const fresh = await this.repository.findById(id)
    await this.cache.set(key, fresh, { ttlSeconds: 300 })
    return fresh
{{else}}
    return this.repository.findById(id)
{{/if}}
  }
  // noah:keep:end methods
}
