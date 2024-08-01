from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, TEXT
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime

Base = declarative_base()

class IceCream(Base):
    __tablename__ = 'ice_creams'

    id = Column(Integer, primary_key=True)
    brand = Column(String(50), nullable=False)
    price = Column(Integer, nullable=False)
    category = Column(String(50), nullable=False)
    name = Column(String(50), nullable=False)
    image = Column(TEXT, nullable=False)

class Review(Base):
    __tablename__ = 'reviews'

    id = Column(Integer, primary_key=True)
    ice_cream_id = Column(Integer, ForeignKey('ice_creams.id'), nullable=False)
    rating = Column(Integer, nullable=False)
    comment = Column(String(255))
    password = Column(String(50), nullable=False)
    created_at = Column(DateTime, default=datetime.now)

class Deal(Base):
    __tablename__ = 'deals'

    id = Column(Integer, primary_key=True)
    ice_cream_id = Column(Integer, ForeignKey('ice_creams.id'), nullable=False)
    comment = Column(String(255))
    bought_at = Column(DateTime, nullable=True)
    password = Column(String(50), nullable=False)
    created_at = Column(DateTime, default=datetime.now)