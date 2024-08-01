from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class IceCreamBase(BaseModel):
    brand: str
    price: int
    category: str
    name: str
    image: str

class IceCreamCreate(IceCreamBase):
    pass

class IceCream(IceCreamBase):
    id: int

    class Config:
        orm_mode: True