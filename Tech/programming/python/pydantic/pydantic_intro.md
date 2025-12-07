A Pydantic model is an object, similar to a Python dataclass, that defines and stores data about an entity with annotated fields. Unlike dataclasses, Pydantic’s focus is centered around automatic data parsing, validation, and serialization.

To define your model, you create a class that inherits from Pydantic’s BaseModel and the names and expected types of your class fields via annotations.

```python
from datetime import date
from uuid import UUID, uuid4
from enum import Enum
from pydantic import BaseModel, EmailStr

class Department(Enum):
    HR = "HR"
    SALES = "SALES"
    IT = "IT"
    ENGINEERING = "ENGINEERING"

class Employee(BaseModel):
    employee_id: UUID = uuid4()
    name: str
    email: EmailStr
    date_of_birth: date
    salary: float
    department: Department
    elected_benefits: bool
```

Pydantic’s BaseModel is equipped with a suite of methods that make it easy to create models from other objects, such as dictionaries and JSON. For example, if you want to instantiate an Employee object from a dictionary, you can use the .model_validate()

**json data validation**   
.model_validate_json() to validate and create an Employee object from new_employee_json   

JSON is powerful because JSON is one of the most popular ways to transfer data across the web. This is one of the reasons why FastAPI relies on Pydantic to create REST APIs.   


### create json schema from pydantic model 
create a JSON schema from your Employee model.

JSON schemas tell you what fields are expected and what values are represented in a JSON object. You can think of this as the JSON version of your Employee class definition. Here’s how you generate a JSON schema for Employee  


### Fields 
The Field class allows you to customize and add metadata to your model’s fields.   


. Here’s a breakdown of the Field parameters you used to add additional validation and metadata to your fields:

- **default_factory**: You use this to define a callable that generates default values. In the example above, you set default_factory to uuid4. This calls uuid4() to generate a random UUID for employee_id when needed. You can also use a lambda function for more flexibility.
- **frozen**: This is a Boolean parameter you can set to make your fields immutable. This means, when frozen is set to True, the corresponding field can’t be changed after your model is instantiated. In this example, employee_id, name, and date_of_birth are made immutable using the frozen parameter.
- **min_length**: You can control the length of string fields with min_length and max_length. In the example above, you ensure that name is at least one character long.
- **pattern**: For string fields, you can set pattern to a regex expression to match whatever pattern you’re expecting for that field. For instance, when you use the regex expression in the example above for email, Pydantic will ensure that every email ends with @example.com.
- **alias**: You can use this parameter when you want to assign an alias to your fields. For example, you can allow date_of_birth to be called birth_date or salary to be called compensation. You can use these aliases when instantiating or serializing a model.
- **gt**: This parameter, short for “greater than”, is used for numeric fields to set minimum values. In this example, setting gt=0 ensures salary is always a positive number. Pydantic also has other numeric constraints, such as lt which is short for “less than”.
- **repr**: This Boolean parameter determines whether a field is displayed in the model’s field representation. In this example, you won’t see date_of_birth or salary when you print an Employee instance.


```python
class Employee(BaseModel):
    employee_id: UUID = Field(default_factory=uuid4, frozen=True)
    name: str = Field(min_length=1, frozen=True)
    email: EmailStr = Field(pattern=r".+@example\.com$")
    date_of_birth: date = Field(alias="birth_date", repr=False, frozen=True)
    salary: float = Field(alias="compensation", gt=0, repr=False)
    department: Department
    elected_benefits: bool

```

### Field Validators and Model Validator
Field validators allow you to apply custom validation logic to your BaseModel fields by adding class methods to your model.  

As you can imagine, Pydantic’s field_validator() enables you to arbitrarily customize field validation. However, field_validator() won’t work if you want to compare multiple fields to one another or validate your model as a whole. For this, you’ll need to use model validators.

```python
class Employee(BaseModel):
    employee_id: UUID = Field(default_factory=uuid4, frozen=True)
    name: str = Field(min_length=1, frozen=True)
    email: EmailStr = Field(pattern=r".+@example\.com$")
    date_of_birth: date = Field(alias="birth_date", repr=False, frozen=True)
    salary: float = Field(alias="compensation", gt=0, repr=False)
    department: Department
    elected_benefits: bool

    @field_validator("date_of_birth")
    @classmethod
    def check_valid_age(cls, date_of_birth: date) -> date:
        today = date.today()
        eighteen_years_ago = date(today.year - 18, today.month, today.day)

        if date_of_birth > eighteen_years_ago:
            raise ValueError("Employees must be at least 18 years old.")

        return date_of_birth

    @model_validator(mode="after")
    def check_it_benefits(self) -> Self:
        department = self.department
        elected_benefits = self.elected_benefits

        if department == Department.IT and elected_benefits:
            raise ValueError(
                "IT employees are contractors and don't qualify for benefits"
            )
        return self
```

### Function Validation
While BaseModel is Pydantic’s bread and butter class for validating data schemas, you can also use Pydantic to validate function arguments using the @validate_call decorator. This allows you to create robust functions with informative type errors without having to manually implement validation logic.

