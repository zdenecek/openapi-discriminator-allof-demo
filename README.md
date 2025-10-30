## Polymorphism & Discriminator in OpenAPI and Python code generation tools.


We have a simple class hierarchy:

```python
class Pet:
    pass

class Cat(Pet):
    name: str

class Dog(Pet):
    bark: str

class PetContainer:
    pet: Pet
```

This follows the OpenAPI spec example: [https://spec.openapis.org/oas/v3.1.1.html#examples-1](https://spec.openapis.org/oas/v3.1.1.html#examples-1)

How will Python code generation tools handle this?

I've prepared three OpenAPI specs:
- [`openapi1.yaml`](openapi1.yaml): example from the OpenAPI spec with allOf without explicitely listing the subtypes.
- [`openapi2.yaml`](openapi2.yaml): using oneOf in the parent type with discriminator.
- [`openapi3.yaml`](openapi3.yaml): using oneOf in the reference with discriminator.

Then there's a simple scenario:
```python
json_data = """
    {
        "pet": {
            "name": "Meow-Meow",
            "petType": "cat"
        }   
    }
"""

container = PetContainer.model_validate_json(json_data)
```

And we want to check if the generated code can:
- resolve the polymorphic field to the correct subtype - **Is `container.pet` an instance of `Cat`?**
- will the subtype contain the correct field - **does `container.pet.name` exist? Is it `"Meow-Meow"`?**


### What is being checked
- **Goal**: Given three OpenAPI specs (`openapi1.yaml`, `openapi2.yaml`, `openapi3.yaml`), generate Python models/clients and verify how a polymorphic field resolves when `petType` is `"cat"`.
- **Check**: Deserialize a `PetContainer` from JSON and inspect:
  - **type**: the concrete Python type of `container.pet`.
  - **is_cat**: whether `container.pet` is an instance of `Cat`.
- **Scenarios**:
  - `test-datamodel-code-generator-python` - using [datamodel-code-generator](https://github.com/koxudaxi/datamodel-code-generator) to generate Pydantic v2 models.
  - `test-openapi-generator-python` - using [openapi-generator](https://github.com/OpenAPITools/openapi-generator) to generate Python clients.

### Results

| scenario                             | file          | type            | is_cat |
|--------------------------------------|---------------|----------------|---------|
| test-datamodel-code-generator-python | openapi1.yaml | Pet             | false| 
| test-datamodel-code-generator-python | openapi2.yaml | Pet             | false|
| test-datamodel-code-generator-python | openapi3.yaml | Cat             | true|
| test-openapi-generator-python        | openapi1.yaml | Pet             | false|
| test-openapi-generator-python        | openapi2.yaml | Pet             | false|
| test-openapi-generator-python        | openapi3.yaml | PetContainerPet | false|


## Conclusions

Nothing works as expected.


## How to run

run `./run.sh` to run the tests.


## TODOs

Add Java scenario.