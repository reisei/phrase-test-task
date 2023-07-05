FROM python:3.9-slim

RUN apt update && apt upgrade -y

WORKDIR /app

COPY src/ .

RUN pip install -r requirements.txt

CMD ["python", "app.py"]
