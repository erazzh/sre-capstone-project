from locust import HttpUser, task, between

class APIUser(HttpUser):
    wait_time = between(0.1, 0.5)

    @task(3)
    def test_root(self):
        self.client.get("/")

    @task(1)
    def test_health(self):
        self.client.get("/health")