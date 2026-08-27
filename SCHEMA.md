# `pack-manifest.json` — the contract

This file is the whole interface between `noah-cli` and a standards pack. The
two repositories are separate, so the schema cannot be shared through an import:
`noah pack validate` is the contract, and this document is its prose.

Run it before every commit:

```bash
npx @sorodriguez/noah-cli pack validate . --strict
```

---

## The admission rule

A field belongs in the manifest only if it

- **(a)** removes an `if (language === ...)` from the CLI, or
- **(b)** removes structural duplication from the content.

A field that only *indexes the file tree* is replaced by a directory
convention. This is why generators carry zero fields: a
`generators: {service: {files: [...]}}` block would restate the directory
listing in JSON and fall out of sync the first time someone adds a file.

Twelve root keys, plus `$schema`:

```
schemaVersion  pack     requires  ignore    reporting  inspect
variables      languages  architectures  patterns  skills  features  aiAdapters
```

---

## 1. Paths

**A path in a template may not contain a filter.** A segment holds a bare
`{{var}}` and nothing else.

This is not a style preference. `|` and `:` are illegal in NTFS filenames, so a
template named

```
{{serviceName|pascal|ensureSuffix:Service}}.java.tpl
```

makes the whole standards repository impossible to `git clone` on Windows.
Every derivation is declared instead as a `VariableDef` with `transform[]`:

```json
{
  "id": "serviceClass",
  "sources": [{ "from": "derive", "template": "{{serviceName}}" }],
  "transform": [["pascal"], ["ensureSuffix", "Service"]]
}
```

`noah pack validate` rejects `< > : " | ? *`, control characters, a trailing
space or dot, and the reserved basenames `CON PRN AUX NUL COM1-9 LPT1-9` — in
any path in the pack, on all three platforms.

---

## 2. Section numbering

**The number written in a fragment is authoritative. Nothing renumbers it.**

The linter prints `Rule Reference: <doc> (Section 2.1)`. If the compiler could
shift a number, that citation would point at whatever happened to land there, so
there is no `sections` field, no re-basing and no auto-assignment.

Prefixes are CLI constants:

| Prefix | Source | Citable by a rule |
|---|---|---|
| `0.x` | `noah/usage.md` — how to drive Noah | **no** |
| `1`–`4` | the architecture's own `rules.md` | yes |
| `5.<n>` | one fixed slot per pattern | yes |
| `6.x` | detected skills | **no** |
| `7.x` | feature design docs | **no** |

### `noah/usage.md`

The one piece of context Noah would otherwise never supply: itself. It is
emitted first, always-on, for every architecture, and it is what tells an agent
that `noah inspect validate` exists, what the exit codes mean, and that code
inside `noah:keep` markers is the safe place to write.

It is deliberately **not** a detected skill. A skill describes a tool the
project happens to use; this describes the tooling that is compiling the rules.
It also has to work on the very first `noah init`, before any project state
exists for a detector to find.

The prose lives here, in the pack, so the CLI hardcodes no guidance and a fork
can rewrite it for its own conventions.

Skills and features are numbered by position and are **not citable**: a rule
pointing at `6.2` would move the moment a different project contains a different
set of tools.

A compiled document may have gaps — `5.1` and `5.3` with no `5.2` when only two
of three patterns are active. That is correct.

Every section a rule cites must exist as a markdown heading (`## 2.1 Title`) in
the architecture's `rules.md` **or in an ancestor's**, because `extends`
inherits rules and the parent documents them.

---

## 3. Import extraction

`languages[].imports[]` is a LIST, one entry per syntactic form, not one
mega-regex:

```json
{ "id": "esm",     "regex": "^[ \\t]*import\\s+(?:[^;'\"]*?from\\s+)?['\"]([^'\"]+)['\"]" },
{ "id": "require", "regex": "\\brequire\\(\\s*['\"]([^'\"]+)['\"]\\s*\\)" }
```

Adding Python is two JSON objects, and a failure can name the pattern that
matched (`typescript/dynamic`).

### `comment.strings` is required whenever `comment` is present

Without string delimiters nothing is blanked, and every Python docstring, Java
text block and TypeScript template literal containing the word `import` becomes
a violation — silently. With that goes the entire argument for using regexes
instead of shipping four AST parsers.

A delimiter is treated as raw/multiline when it is a backtick or three
characters long. One-character delimiters are not blanked across newlines,
because an unterminated quote would otherwise swallow the rest of the file.

### The mask is a mask, not a source

The regexes run against the **raw** source. The comment-stripped text is only
consulted to ask whether a match *started* in code — the `import` keyword is
code even though the specifier after it is legitimately inside quotes. Running
the regexes against the stripped text would capture nothing at all.

### `within` for Go

Go's parenthesised `import ( ... )` block needs a bare indented string to be
matched, which would otherwise hit every indented string in the file. `within`
restricts a pattern to `[open, close)` regions:

```json
{ "id": "block", "regex": "^[ \\t]+(?:[\\w.]+[ \\t]+)?\"([^\"]+)\"",
  "within": { "open": "^import[ \\t]*\\($", "close": "^\\)$" } }
```

Requires the `import-region` feature.

### Known limitations

Accepted deliberately, in exchange for not shipping a parser per language:
macro-generated imports, re-exports resolved transitively, and imports built by
string concatenation are not seen. Suppress a false positive with
`// noah-ignore-next-line <ruleId>` or set `rules.<id>.severity` to `warn`.

---

## 4. The template engine

The entire grammar:

```
{{ path | filter | filter:arg }}
{{#if path}} … {{else}} … {{/if}}
{{#unless path}} … {{/unless}}
{{#each path}} … {{/each}}      this, this.field, @index, @key, @first, @last
{{! comment }}
{{raw}} … {{/raw}}              emitted verbatim, for Go text/template
\{{                             a literal "{{"
```

- An **unquoted** filter argument is trimmed, so `ensureSuffix:Service ` cannot
  put a trailing space into a class name. A **quoted** argument is preserved
  exactly (`join:', '`) and may contain a literal `|`.
- `{{#each}}` does not hoist the item's keys into scope. Only `this`, `this.x`
  and the `@` locals resolve, so static analysis stays reliable and a field name
  can never silently shadow a variable.
- `{{{x}}}` is an explicit error: Noah does not HTML-escape, so `{{x}}` already
  emits raw text.

Eighteen filters, a closed set:

```
pascal camel kebab snake screaming dot title      (tokenising)
upper lower trim path dotPath regex               (raw)
ensureSuffix stripSuffix ensurePrefix stripPrefix
plural singular join
```

`plural` and `singular` require `filter-inflect`; block syntax requires
`template-blocks`. A pack using an undeclared feature fails validation, so an
older CLI can never emit `{{#if …}}` as literal text into a source file.

### Identifier tokenisation

`PaymentService` → `payment|service`, `IOService` → `io|service`,
`userID` → `user|id`. Three limitations are frozen as tests rather than fixed:
`OAuth2Client` splits as `o|auth|2|client`, `user2FAToken` as
`user|2|fa|token`, and non-ASCII letters are dropped.

---

## 5. Two families of markers

They look alike and mean opposite things:

| Marker | Written by | Owned by | Meaning |
|---|---|---|---|
| `noah:begin:<hash>` … `noah:end` | the compiler, in `CLAUDE.md` | Noah | do not edit inside |
| `noah:keep:start <id>` … `noah:keep:end <id>` | a generator, in source | **you** | survives regeneration |

The keep-block comment token is chosen by the **destination file's extension**,
never by the architecture's language: one generator emits `.java`,
`application.yml` and `Dockerfile` in the same run, and `//` in a YAML file is
invalid syntax the harvester would then never find again.

---

## 6. Skills

All detectors of a skill are evaluated and their captures merged. Short-circuit
applies only inside an `any` group.

Stopping at the first match is what breaks `{{skill.prisma.provider}}`: detector
0 (`dep: @prisma/client`) fires in every Prisma project, detector 1 — the one
that reads the provider out of `schema.prisma` — never runs, and the guide
renders a variable with no value.

A `{{skill.<id>.<key>}}` that resolves to nothing renders as an empty string
with a warning rather than aborting the command. `pack validate` still requires
every such variable to be capturable by at least one detector, so a typo is
caught in CI rather than at a user's terminal.

**Capture values differ by detector kind**: a regex group index for `file`, a
named selector (`"version"`) for `dep`.

**Security.** Capturing from a `.env*` file is rejected outright — the value
would be rendered into a rule file the user then commits. Every captured value
is capped at 120 characters and restricted to `[\w.@/:+-]`.

Four ecosystems are parsed natively: `npm`, `maven`, `go`, `pypi`. Gradle,
NuGet and `pyproject.toml` are expressed with the generic `{file, match}`
detector — two hand-rolled TOML parsers would be exactly the accidental parser
this rule exists to prevent.

---

## 7. Exit codes

Fixed by the CLI, not configurable:

| Code | Meaning |
|---|---|
| 0 | success |
| 1 | findings (violations, drift in `--check`) |
| 2 | **contract**: schemaVersion, `requires.cli`, `requires.features` |
| 3 | usage |
| 4 | environment (git missing, unwritable cache) |
| 5 | project not initialised |
| 6 | network or cache |
| 7 | write conflict |
| 70 | internal |
| 130 | cancelled |

`reporting.exitCode` is clamped to `1..125` excluding `2`. Letting a pack reuse
`2` would make "your code violates the architecture" indistinguishable from
"the tool is misconfigured" — a distinction CI depends on.

---

## 8. Adapters

| id | mode | target |
|---|---|---|
| `cursor` | file | `.cursor/rules/{{name}}.mdc` |
| `claude-code` | **merge** | `CLAUDE.md` |
| `windsurf` | file | `.windsurf/rules/{{name}}.md` |
| `copilot` | file | `.github/instructions/{{name}}.instructions.md` |

`target` may only use `{{name}}`.

A unit's identity is `(kind, id)` — one per architecture, one per pattern, one
per detected skill, one per feature. Globs are derived and only feed the header.
Grouping by glob signature instead produces an architecture file per layer plus
one merged blob of everything else, which breaks the emitted filenames the PRD
requires.

Patterns get their own file under `cursor`, `windsurf` and `copilot`, which load
by glob and therefore pay nothing for an inactive pattern. Under `claude-code`
everything goes into the single delimited block, because `CLAUDE.md` has no
glob-based lazy loading.

---

## 9. Determinism

Enforced by `scripts/lint-determinism.mjs` in the CLI, with a zero-tolerance
allowlist. Each entry is a way the same input produced different output:

- `localeCompare` orders by ICU and the active locale
- `toLocaleUpperCase` under `tr_TR` turns `I` into a dotless `i`, changing every
  acronym token
- APFS returns NFD where Linux returns NFC for the same accented filename, so
  the same file yields a different slug, path and hash
- `Date.now`, `new Date()`, `Math.random`, `randomUUID` put a fresh value into
  generated output

The acceptance suite runs under `LC_ALL=tr_TR.UTF-8 TZ=Asia/Kolkata` and
compares bytes.

---

## 10. Feature reference

| id | Unlocks |
|---|---|
| `arch-extends` | `architectures[].extends` |
| `skill-capture` | `detect[].capture` |
| `adapter-limits` | `aiAdapters[].limits` |
| `pattern-rules` | `patterns[].rules` |
| `template-blocks` | `{{#if}}`, `{{#unless}}`, `{{#each}}` |
| `filter-inflect` | the `plural` and `singular` filters |
| `import-region` | `imports[].within` |

Declare each one used in `requires.features`. An older CLI then fails loudly
instead of degrading in silence.
