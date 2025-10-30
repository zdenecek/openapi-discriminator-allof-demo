
from openapi_client import PetContainer, Cat
import json 

json_data = """
    {
        "pet": {
            "name": "Meow-Meow",
            "petType": "cat"
        }   
    }
    """

container = PetContainer.model_validate_json(json_data)

try:
    cat_name = container.pet.name
except AttributeError:
    cat_name = None
    
    
print(json.dumps({
    "cat_name": cat_name,
    "cat_type": type(container.pet).__name__,
    "is_instance_of_cat": isinstance(container.pet, Cat),
}, indent=2, default=str))
