from fastapi import APIRouter, Depends, HTTPException, Query, Path, Body
from database import get_db
from schemas.review import Review, ReviewCreate
from sqlalchemy.orm import Session
from util.password import hash_password
from models import Review as ReviewModel

router = APIRouter()

@router.get("/reviews", response_model=list[Review], description="""
    아이스크림의 리뷰 목록을 조회합니다.
""")
def get_reviews(
    db: Session = Depends(get_db),
    ice_cream_id: int = Query(..., description="아이스크림의 ID"),
    limit: int = Query(10, description="한 번에 조회할 리뷰의 개수"),
    skip: int = Query(0, description="건너뛸 리뷰의 개수"),
):
    reviews = db.query(ReviewModel)\
        .filter(ReviewModel.ice_cream_id == ice_cream_id)\
        .limit(limit).offset(skip).all()

    return reviews

@router.post("/reviews", response_model=Review, description="""
    아이스크림에 리뷰를 작성합니다.
""")
def create_review(
    db: Session = Depends(get_db),
    review: ReviewCreate = Body(),
):
    review = ReviewModel(
        ice_cream_id=review.ice_cream_id,
        rating=review.rating,
        comment=review.comment,
        password=hash_password(review.password)
    )
    db.add(review)
    db.commit()
    db.refresh(review)
    return review

@router.delete("/reviews/{review_id}")
def delete_review(
    db: Session = Depends(get_db),
    review_id: int = Path(..., description="삭제할 리뷰의 ID"),
):
    review = db.query(ReviewModel).get(review_id)
    if review is None:
        raise HTTPException(status_code=404, detail="리뷰를 찾을 수 없습니다.")
    db.delete(review)
    db.commit()
    return review