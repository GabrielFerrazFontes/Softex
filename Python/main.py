from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from database import SessionLocal, engine, Base
import models, schemas

app = FastAPI()

Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.post("/usuarios", response_model=schemas.UserResponse)
def criar_usuario(user: schemas.UserCreate, db: Session = Depends(get_db)):
    novo = models.User(nome=user.nome)
    db.add(novo)
    db.commit()
    db.refresh(novo)
    return novo

@app.get("/usuarios", response_model=list[schemas.UserResponse])
def listar_usuarios(db: Session = Depends(get_db)):
    return db.query(models.User).all()