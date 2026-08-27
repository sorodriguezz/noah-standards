import { Injectable } from '@nestjs/common'
import { PrismaService } from '../../../shared/prisma.service'
import type { {{domainClass}}Repository } from '../domain/{{serviceFile}}.repository'
import { {{domainClass}} } from '../domain/{{serviceFile}}.entity'

/**
 * INFRASTRUCTURE layer. Implements the domain's repository port and maps the
 * persistence model to the domain model explicitly — the domain entity must not
 * be the ORM model.
 */
@Injectable()
export class {{domainClass}}PrismaRepository implements {{domainClass}}Repository {
  constructor(private readonly prisma: PrismaService) {}

  async findById(id: string): Promise<{{domainClass}}> {
    const row = await this.prisma.{{serviceFile}}.findUniqueOrThrow({ where: { id } })
    return this.toDomain(row)
  }

  async save(entity: {{domainClass}}): Promise<{{domainClass}}> {
    const row = await this.prisma.{{serviceFile}}.upsert({
      where: { id: entity.id },
      create: this.toRow(entity),
      update: this.toRow(entity),
    })
    return this.toDomain(row)
  }

  // noah:keep:start mapping
  private toDomain(row: { id: string }): {{domainClass}} {
    return new {{domainClass}}(row.id)
  }

  private toRow(entity: {{domainClass}}): { id: string } {
    return { id: entity.id }
  }
  // noah:keep:end mapping
}
