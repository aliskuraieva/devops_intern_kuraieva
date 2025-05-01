FROM python:3.11-alpine3.20

WORKDIR /app
COPY . /app

RUN pip install -r requirements.txt

RUN chmod +x /app/start.sh

CMD ["sleep", "3600"]
