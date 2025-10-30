

FILE="$1"

mkdir -p tmp-client
poetry run openapi-generator-cli generate -i $FILE -o tmp-client -g python
    
