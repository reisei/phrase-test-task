FROM python:3.9-slim

RUN apt update && apt upgrade -y

WORKDIR /app

COPY src/requirements.txt .

RUN pip install -r requirements.txt

COPY src/* ./

CMD ["python", "app.py"]
