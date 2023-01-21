FROM python:3.6-slim as phase1app
ENV PYTHONUNBUFFERED=1 
WORKDIR /usr/src/app
#Copy app files
COPY flask-api/ ./
#Copy requrements from the text file
WORKDIR /wheels
COPY flask-api/requirements.txt ./requirements.txt

RUN     pip install -r requirements.txt 
CMD ["python", "run_app.py"]

FROM eeacms/pylint:latest as pahselint
WORKDIR /code
COPY --from=phase1app /usr/src/app/pylint.cfg /etc/pylint.cfg
COPY --from=phase1app /usr/src/app/*.py ./
COPY --from=phase1app /usr/src/app/api ./api
RUN ["/docker-entrypoint.sh", "pylint"]

FROM python:2 as unit-tests
WORKDIR /usr/src/app
COPY --from=phase1app /wheels /wheels
RUN     pip install -r /wheels/requirements.txt \
                      -f /wheels \
       && rm -rf /wheels \
       && rm -rf /root/.cache/pip/* 

COPY --from=phase1app /usr/src/app/ ./
RUN ["make", "test"]

FROM python:3.6-slim as serve
WORKDIR /usr/src/app
COPY --from=phase1app /wheels /wheels
RUN     pip install -r /wheels/requirements.txt \
                      -f /wheels \
       && rm -rf /wheels \
       && rm -rf /root/.cache/pip/* 

COPY --from=phase1app /usr/src/app/*.py ./
COPY --from=phase1app /usr/src/app/api ./api
CMD ["python", "run_app.py"]
