from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from database import SessionLocal, engine, Base
from datetime import datetime

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

@app.post("/ciclos", response_model=schemas.CicloResponse)
def criar_ciclo(ciclo: schemas.CicloCreate, db: Session = Depends(get_db)):
    
    novo_ciclo = models.Ciclo(
        valor_total=ciclo.valor_total,
        periodo=ciclo.periodo,
        diaria=ciclo.diaria,
        id_usuario=ciclo.id_usuario
    )

    gasto_total = 0

    for dia in ciclo.dias:
        novo_dia = models.Dia(
            data=dia.data,
            saldo=dia.saldo
        )

        for gasto in dia.gastos:
            novo_gasto = models.Gasto(
                descricao=gasto.descricao,
                valor=gasto.valor
            )
            gasto_total += gasto.valor
            novo_dia.gastos.append(novo_gasto)

        novo_ciclo.dias.append(novo_dia)

    novo_ciclo.gasto_total = gasto_total

    db.add(novo_ciclo)
    db.commit()
    db.refresh(novo_ciclo)

    return novo_ciclo

@app.get("/ciclos/{ciclo_id}", response_model=schemas.CicloResponse)
def get_ciclo(ciclo_id: int, db: Session = Depends(get_db)):
    ciclo = db.query(models.Ciclo).filter(models.Ciclo.id == ciclo_id).first()
    return ciclo

from sqlalchemy.orm import joinedload

@app.get("/usuario/ciclos/{user_id}", response_model=list[schemas.CicloResponse])
def get_all_ciclos(user_id: int, db: Session = Depends(get_db)):
    ciclos = db.query(models.Ciclo)\
        .options(
            joinedload(models.Ciclo.dias)
            .joinedload(models.Dia.gastos)
        )\
        .filter(models.Ciclo.id_usuario == user_id)\
        .all()

    return ciclos

@app.post("/ciclos/lote", response_model=list[schemas.CicloResponse])
def criar_varios(ciclos: list[schemas.CicloCreate], db: Session = Depends(get_db)):
    
    resultados = []

    for ciclo in ciclos:
        novo_ciclo = models.Ciclo(
            valor_total=ciclo.valor_total,
            periodo=ciclo.periodo,
            diaria=ciclo.diaria,
            id_usuario=ciclo.id_usuario
        )

        gasto_total = 0

        for dia in ciclo.dias:
            novo_dia = models.Dia(
                data=dia.data,
                saldo=dia.saldo
            )

            for gasto in dia.gastos:
                novo_gasto = models.Gasto(
                    titulo=gasto.titulo,
                    valor=gasto.valor
                )
                gasto_total += gasto.valor
                novo_dia.gastos.append(novo_gasto)

            novo_ciclo.dias.append(novo_dia)

        novo_ciclo.gasto_total = gasto_total

        db.add(novo_ciclo)
        resultados.append(novo_ciclo)

    db.commit()

    return resultados

