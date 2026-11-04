"""Simulated users for the demo: people signing in, browsing and writing their items, at a low steady rate.

    uvx --from locust locust -f loadtest/locustfile.py --headless -u 4 -r 1 --host http://127.0.0.1:8100

Accounts are the seed's (customer1@example.com ... customer2000@example.com, password demo-password).
"""

from __future__ import annotations

import random

from locust import HttpUser, between, task

API = "/api/v1"
THINGS = ["Send the report", "Renew the licence", "Ship the sample", "Review the draft", "Pay the supplier"]


class Customer(HttpUser):
    wait_time = between(2, 6)

    def on_start(self) -> None:
        email = f"customer{random.randint(1, 2000)}@example.com"
        answer = self.client.post(f"{API}/login/access-token", data={"username": email, "password": "demo-password"},
                                  name=f"{API}/login/access-token")
        self.client.headers["Authorization"] = f"Bearer {answer.json().get('access_token', '')}"

    @task(8)
    def my_items(self) -> None:
        self.client.get(f"{API}/items/?skip=0&limit=20", name=f"{API}/items/")

    @task(3)
    def me(self) -> None:
        self.client.get(f"{API}/users/me", name=f"{API}/users/me")

    @task(2)
    def home(self) -> None:
        self.client.get("/", name="/")

    @task(1)
    def add_and_remove(self) -> None:
        made = self.client.post(f"{API}/items/", json={"title": random.choice(THINGS), "description": "from a person"},
                                name=f"{API}/items/")
        if made.ok:
            self.client.delete(f"{API}/items/{made.json()['id']}", name=f"{API}/items/{{id}}")
