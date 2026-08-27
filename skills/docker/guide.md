This project ships with **Docker**.

## Commands

```bash
docker compose up -d
docker compose logs -f <service>
docker compose down -v          # -v also drops volumes
docker build -t app:dev .
```

## Do

- Use a multi-stage build: compile in a full image, copy the artefact into a
  slim runtime. It cuts both image size and attack surface.
- Order Dockerfile layers from least to most frequently changed. Copying the
  lockfile and installing before copying source is what makes rebuilds fast.
- Pin base images to a digest or at least a minor tag. `:latest` makes builds
  irreproducible.
- Add a `.dockerignore`. Without one the whole `node_modules` and `.git` go into
  the build context on every build.
- Run as a non-root user in the final stage.

## Don't

- Do not bake secrets into an image. Every layer is readable by anyone who can
  pull it.
- Do not run `apt-get upgrade` in a build; it makes the image non-reproducible.
- Do not use `docker compose down -v` casually — it deletes the volumes.
