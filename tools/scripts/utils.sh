current_dir="$PWD"

create_env() {
    declare -a projectDirs=(
        "$current_dir"
    )

    for project in "${projectDirs[@]}"; do
        env_file="$project/.env"
        example_content=$(<"$project/.env.example")
        echo "$example_content" >"$env_file"
    done
}

setup() {
    pnpm seed:c2c $current_dir
    pnpm migrate:dev
    pnpm seed:project
    pnpm seed:networks  $current_dir
}

graph_setup() {
    pnpm graph:create-local
    graph_url=$(pnpm graph:deploy-local | grep -o 'http://[^ ]*' | tail -1)
    export graph_url
}

# seed_settings(){
#     pnpm seed:settings $graph_url
# }

drop_pg_database() {
    CONTAINER_NAME=postgres
    DB_NAME=$1
    docker exec -i "$CONTAINER_NAME" psql -U "rahat" -c "DROP DATABASE \"rahat-c2c\" WITH (FORCE);"
}

rm_modules() {
    rm -rf dist node_modules tmp
}

gen_prisma() {
    pnpm prisma:generate
}
