package {{packageName}}.application;

import {{packageName}}.domain.port.{{domainName}}Repository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
{{#if pattern.circuit-breaker}}
import io.github.resilience4j.circuitbreaker.annotation.CircuitBreaker;
{{/if}}

/**
 * Application service for {{domainName}}.
 *
 * Owns the transaction boundary and orchestrates the domain. It depends on the
 * {{domainName}}Repository PORT, never on a persistence implementation.
 */
@Service
public class {{serviceClass}} {

    private final {{domainName}}Repository repository;

    public {{serviceClass}}({{domainName}}Repository repository) {
        this.repository = repository;
    }

    // noah:keep:start methods
    @Transactional(readOnly = true)
{{#if pattern.circuit-breaker}}
    @CircuitBreaker(name = "{{domainName}}", fallbackMethod = "findByIdFallback")
{{/if}}
    public {{domainName}} findById(String id) {
        return repository.findById(id)
            .orElseThrow(() -> new {{domainName}}NotFoundException(id));
    }
    // noah:keep:end methods
}
