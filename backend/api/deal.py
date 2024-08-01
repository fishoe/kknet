from fastapi import APIRouter, Depends, HTTPException, Query, Path, Body, Header
from database import get_db
from schemas.review import Deal, DealCreate
from sqlalchemy.orm import Session
from util.password import hash_password
from models import Deal as DealModel
from models import IceCream as IceCreamModel

router = APIRouter()

@router.get("/deals", response_model=list[Deal], description="""
    아이스크림의 제보 목록을 조회합니다.
""")
def get_deals(
    db: Session = Depends(get_db),
    ice_cream_id: int = Query(..., description="아이스크림의 ID"),
    limit: int = Query(10, description="한 번에 조회할 제보의 개수"),
    skip: int = Query(0, description="건너뛸 제보의 개수"),
):
    deals = db.query(DealModel)\
        .filter(DealModel.ice_cream_id == ice_cream_id)\
        .limit(limit).offset(skip).all()

    return deals

@router.post("/deals", response_model=Deal, description="""
    아이스크림에 리뷰를 작성합니다.
""")
def create_deal(
    db: Session = Depends(get_db),
    deal: DealCreate = Body(),
):
    ice_cream = db.query(IceCreamModel).get(deal.ice_cream_id)
    if ice_cream is None:
        raise HTTPException(status_code=404, detail="아이스크림을 찾을 수 없습니다.")
    deal = DealModel(
        ice_cream_id=deal.ice_cream_id,
        comment=deal.comment,
        password=hash_password(deal.password)
    )
    db.add(deal)
    db.commit()
    db.refresh(deal)
    return deal

@router.delete("/deals/{deal_id}", description="""
    제보를 삭제합니다.
""", response_model=Deal)
def delete_deal(
    db: Session = Depends(get_db),
    deal_id: int = Path(..., description="삭제할 제보의 ID"),
    password: str = Header(..., description="제보 비밀번호"),
):
    deal = db.query(DealModel).get(deal_id)
    if deal is None:
        raise HTTPException(status_code=404, detail="리뷰를 찾을 수 없습니다.")
    if deal.password != hash_password(password):
        raise HTTPException(status_code=403, detail="비밀번호가 일치하지 않습니다.")
    db.delete(deal)
    db.commit()
    return deal