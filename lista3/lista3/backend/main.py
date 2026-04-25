import sqlite3
import os
from contextlib import contextmanager
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

DB_PATH = os.path.join(os.path.dirname(__file__), "data", "users.db")

os.makedirs(os.path.dirname(DB_PATH), exist_ok=True)


def init_db():
    with sqlite3.connect(DB_PATH) as conn:
        conn.execute("""
            CREATE TABLE IF NOT EXISTS users (
                id      INTEGER PRIMARY KEY AUTOINCREMENT,
                name    TEXT    NOT NULL,
                age     INTEGER NOT NULL,
                address TEXT    NOT NULL
            )
        """)


@contextmanager
def get_db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    try:
        yield conn
        conn.commit()
    finally:
        conn.close()


app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

init_db()


class UserBody(BaseModel):
    name: str
    age: int
    address: str


@app.get("/users")
def list_users():
    with get_db() as conn:
        rows = conn.execute("SELECT * FROM users").fetchall()
        return [dict(r) for r in rows]


@app.get("/users/{user_id}")
def get_user(user_id: int):
    with get_db() as conn:
        row = conn.execute("SELECT * FROM users WHERE id = ?", (user_id,)).fetchone()
        if row is None:
            raise HTTPException(status_code=404, detail="User not found")
        return dict(row)


@app.post("/users", status_code=201)
def create_user(body: UserBody):
    with get_db() as conn:
        cursor = conn.execute(
            "INSERT INTO users (name, age, address) VALUES (?, ?, ?)",
            (body.name, body.age, body.address),
        )
        return {"id": cursor.lastrowid, "name": body.name, "age": body.age, "address": body.address}


@app.put("/users/{user_id}")
def update_user(user_id: int, body: UserBody):
    with get_db() as conn:
        cursor = conn.execute(
            "UPDATE users SET name = ?, age = ?, address = ? WHERE id = ?",
            (body.name, body.age, body.address, user_id),
        )
        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="User not found")
        return {"id": user_id, "name": body.name, "age": body.age, "address": body.address}


@app.delete("/users/{user_id}", status_code=204)
def delete_user(user_id: int):
    with get_db() as conn:
        cursor = conn.execute("DELETE FROM users WHERE id = ?", (user_id,))
        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="User not found")
