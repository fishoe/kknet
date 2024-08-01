from fastapi import APIRouter, Depends, HTTPException, Query, Path
from database import get_db
from schemas.ice_cream import IceCream
from sqlalchemy.orm import Session


router = APIRouter()

@router.get("/ice-creams", description="""
아이스크림의 목록을 조회합니다.
""", response_model=list[IceCream])
def get_ice_creams(
    db: Session = Depends(get_db),
    category: str = Query(None, description="아이스크림의 카테고리"),
    keyword: str = Query(None, description="아이스크림의 이름에 포함된 키워드"),
    limit: int = Query(10, description="한 번에 조회할 아이스크림의 개수"),
    skip: int = Query(0, description="건너뛸 아이스크림의 개수"),
):
    ice_creams = db.query(IceCream)\
        .filter([IceCream.category == category, IceCream.name.contains(keyword)])\
        .limit(limit).offset(skip).all()

    return ice_creams    

@router.get("/ice-creams/{ice_cream_id}", description="""
            특정 아이스크림을 조회합니다.
""", response_model=IceCream)
def get_ice_cream(
    db: Session = Depends(get_db),
    ice_cream_id: int = Path(..., description="조회할 아이스크림의 ID"),
):
    ice_cream = db.query(IceCream).get(ice_cream_id)
    if ice_cream is None:
        raise HTTPException(status_code=404, detail="아이스크림을 찾을 수 없습니다.")
    
    return ice_cream