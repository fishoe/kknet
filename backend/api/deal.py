from fastapi import APIRouter, Depends, HTTPException, Query, Path, Body
from database import get_db
from schemas.review import Deal, DealCreate
from sqlalchemy.orm import Session
from util.password import hash_password
from models import Deal as DealModel

router = APIRouter()

@router.get("/deals", response_model=list[Deal], description="""
    아이스크림의 제보 목록을 조회합니다.
""")
def get_reviews(
    db: Session = Depends(get_db),
    ice_cream_id: int = Query(..., description="아이스크림의 ID"),
    limit: int = Query(10, description="한 번에 조회할 제보의 개수"),
    skip: int = Query(0, description="건너뛸 제보의 개수"),
):
    reviews = db.query(DealModel)\
        .filter(DealModel.ice_cream_id == ice_cream_id)\
        .limit(limit).offset(skip).all()

    return reviews

@router.post("/deals", response_model=Deal, description="""
    아이스크림에 리뷰를 작성합니다.
""")
def create_review(
    db: Session = Depends(get_db),
    review: DealCreate = Body(),
):
    review = DealModel(
        ice_cream_id=review.ice_cream_id,
        rating=review.rating,
        comment=review.comment,
        password=hash_password(review.password)
    )
    db.add(review)
    db.commit()
    db.refresh(review)
    return review

@router.delete("/deals/{deals_id}", description="""
    제보를 삭제합니다.
""", response_model=Deal)
def delete_review(
    db: Session = Depends(get_db),
    deals_id: int = Path(..., description="삭제할 제보의 ID"),
):
    review = db.query(DealModel).get(deals_id)
    if review is None:
        raise HTTPException(status_code=404, detail="리뷰를 찾을 수 없습니다.")
    db.delete(review)
    db.commit()
    return review