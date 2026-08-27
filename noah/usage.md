## 0.1 What Noah is, in this project

This project uses **Noah** to keep architecture rules where you can read them.
The rules in the sections below are not advice — there is a command that checks
your work against them and tells you which one you broke.

You do not need to memorise the rules. You need to know the three commands.

## 0.2 Before you claim a change is done

```bash
noah inspect validate
```

Exit `0` means no violations. Exit `1` prints one block per violation:

```
❌ ARCHITECTURE VIOLATION DETECTED
File: src/main/java/com/app/controller/UserController.java
Issue: Direct import of 'java.sql.Connection' in Controller level.
Rule Reference: .cursor/rules/spring-hexagonal.mdc (Section 2.1)
```

The `Rule Reference` line points at the exact section of the exact file that
explains the rule. Read that section before changing the code — the fix is
usually "move this to another layer", not "delete the import".

Useful flags:

- `noah inspect validate --json` — the same findings as data, with line numbers.
- `noah inspect validate --explain` — shows which glob assigned each file to a
  layer, when a violation is surprising.
- `noah inspect validate src/payments` — limits the check to one subtree.

## 0.3 Before you write a new class by hand

```bash
noah g                       # what this architecture can scaffold
noah g service PaymentName   # scaffold it, and print the rules for what it made
```

Scaffolding is not a shortcut — it puts each file in the layer this architecture
expects and prints the rules that apply to it. Writing the same class by hand
usually means putting it in the wrong directory.

`noah g` refuses to overwrite an existing file. Pass `--on-exists overwrite` to
regenerate deliberately; code inside `noah:keep` markers survives that.

## 0.4 Where it is safe to write

A generated file has regions marked like this:

```
// noah:keep:start methods
   ...your code lives here and survives regeneration...
// noah:keep:end methods
```

Anything **outside** those markers is rewritten the next time the generator
runs. Put your logic inside them. The same applies to the block delimited by
`<!-- noah:begin -->` in a rules file — except that block is Noah's, and editing
it makes the next command stop with a conflict rather than silently discard your
edit.

## 0.5 Understanding an unfamiliar part of the codebase

```bash
noah inspect tree            # module structure, annotated with layers
noah inspect tree --layer domain
```

Cheaper than listing directories: it skips build output and dependencies, and
labels each directory with the architecture layer it belongs to.

## 0.6 When the rules look stale

```bash
noah sync --check    # exit 1 if the compiled context is out of date
noah sync            # bring it up to date
noah skill detect    # re-scan for tools after adding a dependency
```

Run `noah skill detect` after adding a dependency: it injects the usage guide
for tools this project actually has, and removes guides for tools it dropped.

## 0.7 Exit codes

| Code | Meaning | What to do |
|---|---|---|
| 0 | success | continue |
| 1 | findings | read the violations and fix them |
| 2 | contract mismatch | the CLI and the standards pack disagree; tell a human |
| 3 | wrong usage | re-read `noah help <command>` |
| 5 | project not initialised | a human must run `noah init` |
| 7 | write conflict | a file was edited outside Noah; do not use `--force` blindly |

Every command accepts `--help` and `--json`. `noah --help --json` returns the
entire command surface as data, so you never have to guess a flag.
