# Lista 3 — CRUD de Usuários

Aplicação full-stack com Flutter (frontend) e Python/FastAPI (backend) para gerenciar usuários (nome, idade e endereço).

## Pré-requisitos

- Flutter SDK
- Python 3.10+

## Como rodar

### Backend

```bash
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload --port 3000
```

### Frontend

```bash
flutter run   # ou -d chrome para web
```

O banco de dados SQLite é criado automaticamente em `backend/data/users.db` na primeira execução.
