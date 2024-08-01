from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from api.deal import router as deal_router
from api.review import router as review_router
from api.ice_cream import router as ice_cream_router

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(deal_router)
app.include_router(review_router)
app.include_router(ice_cream_router)
