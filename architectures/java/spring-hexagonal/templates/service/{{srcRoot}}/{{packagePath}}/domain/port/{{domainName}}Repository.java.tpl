package {{packageName}}.domain.port;

import {{packageName}}.domain.{{domainName}};
import java.util.Optional;

/**
 * Outbound port for {{domainName}}.
 *
 * Declared by the DOMAIN and implemented in adapter/out. This is the interface
 * that keeps the dependency arrow pointing inward.
 */
public interface {{domainName}}Repository {

    Optional<{{domainName}}> findById(String id);

    {{domainName}} save({{domainName}} entity);

    // noah:keep:start methods
    // noah:keep:end methods
}
