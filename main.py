
    
from schemas1 import PetContainer, Cat
from schemas2 import PetContainer as PetContainer2, Cat as Cat2   
from schemas3 import PetContainer as PetContainer3, Cat as Cat3   
from schemas4 import PetContainer as PetContainer4, Cat as Cat4   

def example(cls, target_cls):
    json_data = """
    {
        "pet": {
            "name": "Meow-Meow",
            "petType": "cat"
        }
    }
    """


    container = cls.model_validate_json(json_data)
    print(container.model_dump_json())
    print(type(container.pet))
    print("is instance of Cat:", isinstance(container.pet, target_cls))
    


print("example with allOf:")
example(PetContainer, Cat)

print("example with oneOf:")
example(PetContainer2, Cat2)

print("example with oneOf in properties and not schema")
example(PetContainer3, Cat3)

print("example with oneOf in properties and allOf in schema")
example(PetContainer4, Cat4)