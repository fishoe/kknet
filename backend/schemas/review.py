from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class ReviewBase(BaseModel):
    ice_cream_id: int
    rating: int
    comment: Optional[str] = None

class ReviewCreate(ReviewBase):
    password: str

class Review(ReviewBase):
    id: int
    created_at: datetime

    class Config:
        orm_mode: True

class DealBase(BaseModel):
    ice_cream_id: int
    comment: Optional[str] = None
    bought_at: Optional[datetime] = None

class DealCreate(DealBase):
    password: str

class Deal(DealBase):
    id: int
    created_at: datetime

    class Config:
        orm_mode: True