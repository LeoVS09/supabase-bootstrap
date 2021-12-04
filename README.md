# Supabase Bootstrap

Bootstrap for local supabase development and experiments

Base on [this guide](https://supabase.com/docs/guides/hosting/docker).

## Requirements

* Docker - for start services locally
* [GNU Make](https://www.gnu.org/software/make/manual/make.html) - shortcuts for scripts. Optional, you can just look in `Makefile`

## Development

For build and start supabase services simply run

```bash
# Copy example `.env`
cp .env.example .env

# Start services
make # or docker-compose up
```

## TODO

* Add triggert for update updated_at on changes
