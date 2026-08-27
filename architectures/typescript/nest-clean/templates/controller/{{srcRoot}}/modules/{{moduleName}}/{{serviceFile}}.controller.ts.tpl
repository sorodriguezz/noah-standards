import { Controller, Get, Param } from '@nestjs/common'
import { {{serviceClass}} } from './application/{{serviceFile}}.service'
import { {{domainClass}}ResponseDto } from './dto/{{serviceFile}}.response.dto'

/**
 * MUST NOT import typeorm, @prisma/client, mongoose, pg, mysql2 or knex.
 * MUST NOT contain business logic.
 */
@Controller('{{moduleName}}')
export class {{domainClass}}Controller {
  constructor(private readonly service: {{serviceClass}}) {}

  // noah:keep:start routes
  @Get(':id')
  async findById(@Param('id') id: string): Promise<{{domainClass}}ResponseDto> {
    return {{domainClass}}ResponseDto.from(await this.service.findById(id))
  }
  // noah:keep:end routes
}
