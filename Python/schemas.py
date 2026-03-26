from pydantic import BaseModel

class UserCreate(BaseModel):
    nome: str

class UserResponse(BaseModel):
    id: int
    nome: str

    class Config:
        from_attributes = True