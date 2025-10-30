
input_file="$1"

poetry run datamodel-codegen --input $input_file --input-file-type openapi \
    --output-model-type pydantic_v2.BaseModel --output schemas.py \
    --snake-case-field  --use-annotated --use-union-operator --target-python-version '3.11'
