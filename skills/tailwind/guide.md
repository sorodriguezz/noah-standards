This project uses **Tailwind CSS**.

## Commands

```bash
npx tailwindcss -i input.css -o output.css --watch
```

## Do

- Extend the theme in `tailwind.config`. Arbitrary values like `w-[437px]`
  scattered through the codebase are a design system that exists nowhere.
- Extract a component when the same class list appears three times, rather than
  reaching for `@apply` everywhere.
- Keep the `content` globs accurate — anything outside them is purged from the
  build and the style silently disappears in production only.

## Don't

- Do not build class names by string concatenation (`` `text-${color}-500` ``).
  The scanner cannot see them and they get purged. Map to complete class names.
- Do not mix a competing utility framework; specificity conflicts follow.
