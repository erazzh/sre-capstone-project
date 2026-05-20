from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"status": "OK", "message": "Service is up and running"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}