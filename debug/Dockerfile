FROM supabase/postgres:13.3.0

# Will install PGAdmin debugger
# Based on https://gist.github.com/jhngrant/c1787346fcb4b0e3001a

RUN apt update && \
    apt install -y postgresql-13-pldebugger

# After start need change /var/lib/postgresql/data/postgresql.conf
# Replace shared_preload_libraries = '' with shared_preload_libraries = 'plugin_debugger'

# You can use this command for it 
# sed -i -e "s/^#shared_preload_libraries.*/shared_preload_libraries = 'plugin_debugger'/" \
#  $(su - postgres -c "psql -c \"show config_file;\""| awk '/.*conf$/ {print $1}')

# And inside database run CREATE EXTENSION pldbgapi;