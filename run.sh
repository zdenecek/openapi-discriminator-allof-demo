

#!/usr/bin/env bash

# set -euo pipefail

SCENARIOS="${1:-test-datamodel-code-generator-python test-openapi-generator-python test-openapi-python-client}"
FILES="${2:-$(ls openapi*.yaml | xargs -n1 basename | tr '\n' ' ')}"

declare -a RESULTS=()

echo "SCENARIOS: $SCENARIOS"
echo "FILES: $FILES"

print_results() {
    if [ ${#RESULTS[@]} -eq 0 ]; then
        echo "No results collected."
        return
    fi
    printf "%-40s | %-24s | %-24s | %-6s\n" "scenario" "file" "type" "is_cat"
    for row in "${RESULTS[@]}"; do
        IFS='|' read -r col1 col2 col3 col4 <<< "$row"
        # Trim leading/trailing whitespace from each column
        col1="${col1## }"; col1="${col1%% }"
        col2="${col2## }"; col2="${col2%% }"
        col3="${col3## }"; col3="${col3%% }"
        col4="${col4## }"; col4="${col4%% }"
        printf "%-40s | %-24s | %-24s | %-6s\n" "$col1" "$col2" "$col3" "$col4"
    done
}

trap print_results EXIT ERR


for scenario in $SCENARIOS; do
    cd $scenario
    echo $PWD
    echo "Running $scenario"
    ./init.sh
    for file in $FILES; do
        echo "Running $file"
        echo "Generating schema"
        ./generate-schema.sh ../$file
        echo "Running test"
        if output=$(./run-test.sh 2>&1); then
            cat_type=$(printf "%s" "$output" | python3 -c 'import sys, json; print(json.load(sys.stdin)["cat_type"])')
            is_cat=$(printf "%s" "$output" | python3 -c 'import sys, json; v=json.load(sys.stdin)["is_instance_of_cat"]; print("true" if v else "false")')
            RESULTS+=("$scenario|$file|$cat_type|$is_cat")
        else
            RESULTS+=("$scenario|$file|ERROR|ERROR")
        fi
    done
    ./deinit.sh
    cd ..
done


