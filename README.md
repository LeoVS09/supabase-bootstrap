# Supabase Bootstrap

Bootstrap for local supabase development and experiments

## Requirements

* Docker - for start services locally
* [Supabase CLI](https://github.com/supabase/cli) - database migrations and supabase manupulation
* [GNU Make](https://www.gnu.org/software/make/manual/make.html) - shortcuts for scripts. Optional, you can just look in `Makefile`

## Development

For build and start supabase services simply run

```bash
make
```

## Knonw Issues

**Error restoring branch main**: open supabase/.branches/main/dump.sql: no such file or directory
-> **Solution**: Try remove `supabase` folder and run `supabase init`. Be aware, part files can be lost.

**Error**: Error response from daemon: No such image: supabase/studio:latest
-> Check [solution in issue](https://github.com/supabase/cli/issues/86)
