package {{packageName}}.adapter.out.persistence;

import {{packageName}}.domain.{{domainName}};
import {{packageName}}.domain.port.{{domainName}}Repository;
import org.springframework.stereotype.Repository;
import java.util.Optional;
{{#if pattern.redis-cache}}
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
{{/if}}

/**
 * Outbound adapter implementing the {{domainName}}Repository port.
 *
 * Maps between the JPA entity and the domain model EXPLICITLY: the domain class
 * must never carry persistence annotations.
 */
@Repository
public class {{domainName}}PersistenceAdapter implements {{domainName}}Repository {

    private final {{domainName}}JpaRepository jpa;
    private final {{domainName}}Mapper mapper;

    public {{domainName}}PersistenceAdapter({{domainName}}JpaRepository jpa, {{domainName}}Mapper mapper) {
        this.jpa = jpa;
        this.mapper = mapper;
    }

    @Override
{{#if pattern.redis-cache}}
    @Cacheable(cacheNames = "{{domainName}}", key = "#id")
{{/if}}
    public Optional<{{domainName}}> findById(String id) {
        return jpa.findById(id).map(mapper::toDomain);
    }

    @Override
{{#if pattern.redis-cache}}
    @CacheEvict(cacheNames = "{{domainName}}", key = "#entity.id")
{{/if}}
    public {{domainName}} save({{domainName}} entity) {
        return mapper.toDomain(jpa.save(mapper.toJpa(entity)));
    }

    // noah:keep:start methods
    // noah:keep:end methods
}
