# syntax=docker/dockerfile:1

# Defining environment
# dev or prod
ARG APP_ENV=dev
# base or base-arm7
ARG BUILD_PLATFORM=base-arm7


# use https://hub.docker.com/r/tiangolo/uwsgi-nginx-flask/ as a parent image. 
# Documentation: https://github.com/tiangolo/uwsgi-nginx-flask-docker
FROM tiangolo/uwsgi-nginx-flask:python3.8 as base
    # RUN echo "Building backend on base image"

# use arm7 version of above to work on raspberry pi, see: https://github.com/tiangolo/uwsgi-nginx-flask-docker/issues/200
FROM guysoft/uwsgi-nginx-flask:python3.8 as base-arm7
    # RUN echo "Building backend on arm7 build of image"


FROM ${BUILD_PLATFORM} as install-requirements
    WORKDIR /app
    COPY ./requirements.txt /app/requirements.txt
    RUN pip3 install -r requirements.txt



# start production server by setting environment variables for uwsgi.ini
FROM install-requirements as start-prod
    COPY . /app/backend
    COPY ./nginx.conf /app/
    # point to our uswsgi.ini
    ENV UWSGI_INI /app/backend/uwsgi.ini
    ENV LISTEN_PORT 8000
    # ENV UWSGI_INI /app/backend/uwsgi-watch.ini
    EXPOSE 8000
    # set working dir correctly because uwsgi.ini is looking for ./app/main.py
    WORKDIR /app/backend


# start development server by setting flask app entry point to the debug main
FROM install-requirements as start-dev
    RUN echo "CRITICAL: Image is using development server"
    COPY . /app/backend
    WORKDIR /app/backend
    EXPOSE 8000
    ENV FLASK_RUN_PORT=8000
    ENV FLASK_APP=app.py
    ENV FLASK_ENV=development
    CMD flask run --host=0.0.0.0



# Pick the correct build route
FROM start-${APP_ENV} as final