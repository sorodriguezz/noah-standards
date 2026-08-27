import { Module } from '@nestjs/common'
import { {{serviceClass}} } from './application/{{serviceFile}}.service'
import { {{domainClass}}Controller } from './{{serviceFile}}.controller'
import { {{domainClass}}RepositoryToken } from './domain/{{serviceFile}}.repository'
import { {{domainClass}}PrismaRepository } from './infrastructure/{{serviceFile}}.prisma.repository'

/**
 * Wires the port token to its implementation. This binding is the only place
 * the application layer's interface meets a concrete class.
 */
@Module({
  controllers: [{{domainClass}}Controller],
  providers: [
    {{serviceClass}},
    { provide: {{domainClass}}RepositoryToken, useClass: {{domainClass}}PrismaRepository },
    // noah:keep:start providers
    // noah:keep:end providers
  ],
  exports: [{{serviceClass}}],
})
export class {{domainClass}}Module {}
