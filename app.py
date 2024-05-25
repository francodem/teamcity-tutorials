from fastapi import FastAPI, Request
import uvicorn
import json


app = FastAPI()


@app.get("/")
def home(request: Request):
    return json.dumps(
        {"status": "ok"}
    )


if __name__ == "__main__":
    uvicorn.run(app=app, host="localhost", port=8000, reload=False)
