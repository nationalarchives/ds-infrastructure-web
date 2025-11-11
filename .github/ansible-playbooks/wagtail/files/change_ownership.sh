
#!/bin/bash

while getopts p: flag
do
    case "${flag}" in
        p) password=${OPTARG};;
    esac
done

if [[ $password == "" ]]; then
    echo "ownership settings in postgress"
    echo ""
    echo "-p [password]"
    echo ""
    echo "Please enter the parameters."
    echo ""

    read -p "Password " password

    if [[ $password == "" ]]; then
        exit
    fi
fi

for tbl in $(PGPASSWORD=$password psql -U postgres -qAt -c "SELECT tablename FROM pg_tables WHERE schemaname = 'public';" etna); do
    PGPASSWORD=$password psql -U postgres -d etna -c "ALTER TABLE \"$tbl\" OWNER TO etna_app_user;"
done

for tbl in $(PGPASSWORD=$password psql -U postgres -qAt -c "SELECT table_name FROM information_schema.views WHERE table_schema = 'public';" etna); do
    PGPASSWORD=$password psql -U postgres -d etna -c "ALTER view \"$tbl\" OWNER TO etna_app_user;"
done

for tbl in $(PGPASSWORD=$password psql -U postgres -qAt -c "SELECT sequence_name FROM information_schema.sequences WHERE sequence_schema = 'public';" etna); do
    PGPASSWORD=$password psql -U postgres -d etna -c "ALTER sequence \"$tbl\" OWNER TO etna_app_user;"
done
