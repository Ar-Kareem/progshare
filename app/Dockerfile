# syntax=docker/dockerfile:1

# dev or prod
ARG mode


FROM python:3.10-alpine AS base
WORKDIR /code
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=8000
RUN apk add --no-cache gcc musl-dev linux-headers
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
EXPOSE 8000
COPY . .

FROM base AS dev-mode
CMD ["flask", "run", "--debug"]

FROM base AS prod-mode
CMD ["gunicorn", "-b", "0.0.0.0:8000", "app:app"]

FROM ${mode}-mode AS final
