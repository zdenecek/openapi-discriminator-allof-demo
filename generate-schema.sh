

for num in {1..4}; do
    poetry run datamodel-codegen --input openapi$num.yaml --input-file-type openapi \
        --output-model-type pydantic_v2.BaseModel --output schemas$num.py \
        --snake-case-field  --use-annotated --use-union-operator --target-python-version '3.11'
done
