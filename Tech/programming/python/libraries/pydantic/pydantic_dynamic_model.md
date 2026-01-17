### Key Considerations
**Immutability**: Pydantic models are typically designed to have a fixed schema at class creation time.   
**Best Practice**: Creating a new, derived model using create_model is the official and safer approach compared to attempting in-place modification of a class's internal structure.  
**Validators**: Validators and computed fields from the base model are automatically inherited in the dynamically created model.   

The recommended way to add dynamic fields to an existing Pydantic model is to use the pydantic.create_model function, using the existing model as a base.   

Avoid modifying internal attributes of a model in-place (like __fields__ or __schema_cache__), as this uses internal APIs and can lead to issues. 

Using pydantic.create_model:   
The create_model function allows you to define a new model dynamically, inheriting all fields, validators, and configurations from the base model, and adding new fields as needed.   
Here is a step-by-step guide:  

1. Define your base model:

```python
from pydantic import BaseModel
from typing import Optional

class ExistingModel(BaseModel):
    id: int
    name: str
```


2. Define a function to create the dynamic model:
```python
from pydantic import create_model

def create_dynamic_model(field_name: str, field_type: type, field_default: Optional[Any] = None):
    # Define the new field as a dictionary key-value pair
    # The value is a tuple of (type, default_value)
    new_field_definition = {field_name: (field_type, field_default)}

    # Create a new model dynamically, using ExistingModel as the base
    DynamicModel = create_model(
        'DynamicModel',
        __base__=ExistingModel,
        **new_field_definition,
    )
    return DynamicModel

```
3.Use the dynamic model:  

```python
# Create a new model with an additional 'email' field that is a required string
DynamicModelWithEmail = create_dynamic_model(field_name='email', field_type=str, field_default=...)

# Instantiate the new model with all required fields
data = {'id': 1, 'name': 'John Doe', 'email': 'john@example.com'}
instance = DynamicModelWithEmail(**data)

print(instance)
# Output: id=1 name='John Doe' email='john@example.com'

# Create a new model with an optional 'age' field
DynamicModelWithOptionalAge = create_dynamic_model(field_name='age', field_type=Optional[int], field_default=None)

data_age = {'id': 2, 'name': 'Jane Doe'}
instance_age = DynamicModelWithOptionalAge(**data_age)
print(instance_age)
# Output: id=2 name='Jane Doe' age=None


```
