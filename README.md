# Supabase Bootstrap

Bootstrap for local supabase development and experiments

Base on [this guide](https://supabase.com/docs/guides/hosting/docker).

## Schema

Schema example consists of multitenant accounts (organisations or company accounts) which can contain multiple users. And profiles which linked to each user, for additional user data.

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

### Setup database

Run `*.sql` queries from `schema/` to postgres database. Connection string by default look like `postgres://postgres:your-super-secret-and-long-postgres-password@localhost:5432/postgres`.

After that you can test your database-supabase setup in `tests/` folder

### Test Supabase

```bash
cd tests/

# Copy example `.env`
cp .env.example .env

# Install dependencies
npm i

# run all tests
npm run test
```

### User signup

For go though real user signup/signin flow you need start `supabase-react` example

```bash
cd supabase-react

# Copy example `.env`
cp .env.example .env

# install dependencies
npm i

# start dev server
npm start
```

Follow instructions in console

### Known Issues

If you getting error `If a new foreign key between these entities was created in the database, try reloading the schema cache.` then restart rest service

```bash
docker-compose restart rest
```

### Debug

**Important**: Postgres support debug function, but it not seems much helpful, so not expect much from that.

Based on [pgAdmin4 guide](https://www.pgadmin.org/docs/pgadmin4/development/debugger.html), you can enable postgres debug by building docker image from `debug/` folder.

```bash
make database # or docker build -t leovs09/supabase-postgres:13.3.0-debug ./debug
```

then start services by

```bash
make # or docker-compose up
```

Replace `shared_preload_libraries = ''` with `shared_preload_libraries = 'plugin_debugger'` in `volumes/db/data/postgresql.conf`.

After that restart database by

```bash
docker-compose restart db 
```

Then run quiery in your database

```bash
CREATE EXTENSION pldbgapi;
```

After that you can debug functions in pgAdmin4
