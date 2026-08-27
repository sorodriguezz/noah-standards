package {{packageName}}.adapter.in.web;

import {{packageName}}.application.{{serviceClass}};
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Inbound adapter. Translates HTTP into a use-case call and back.
 *
 * MUST NOT import java.sql.*, jakarta.persistence.* or org.hibernate.*.
 */
@RestController
@RequestMapping("/api/{{domainName}}")
public class {{domainName}}Controller {

    private final {{serviceClass}} service;

    public {{domainName}}Controller({{serviceClass}} service) {
        this.service = service;
    }

    // noah:keep:start endpoints
    @GetMapping("/{id}")
    public ResponseEntity<{{domainName}}Response> findById(@PathVariable String id) {
        return ResponseEntity.ok({{domainName}}Response.from(service.findById(id)));
    }
    // noah:keep:end endpoints
}
