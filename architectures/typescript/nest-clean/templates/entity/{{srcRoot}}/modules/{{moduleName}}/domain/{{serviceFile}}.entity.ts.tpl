/**
 * Domain entity for {{domainClass}}.
 *
 * No decorators, no framework imports. It must be constructible in a plain unit
 * test with no container and no I/O, and its constructor is where invariants are
 * enforced — an invalid instance should be impossible to create.
 */
export class {{domainClass}} {
  constructor(readonly id: string) {
    if (!id) throw new Error('{{domainClass}} requires an id')
    // noah:keep:start invariants
    // noah:keep:end invariants
  }

  // noah:keep:start behaviour
  // noah:keep:end behaviour
}
