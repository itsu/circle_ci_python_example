VERSION 0.8
FROM python:3
WORKDIR /circle_ci_python_example

build:
  COPY ./requirements.txt .
  RUN pip install -r requirements.txt
  COPY . .

lint:
  FROM +build
  RUN pylint my_media/ media_organizer/

test:
  FROM +build
  COPY ./docker-compose.yml .
  RUN apt-get update
  RUN apt-get install -y postgresql-client
  WITH DOCKER --compose docker-compose.yml
      RUN while ! pg_isready --host=localhost --port=5432 --dbname=my_media --username=example; do sleep 1; done ;\
        python manage.py test
  END
  SAVE ARTIFACT test_results/results.xml test_results/results.xml AS LOCAL ./test_results/results.xml

docker:
  FROM +build
  ENTRYPOINT ["python", "manage.py"," runserver", "0.0.0.0:8000"]
  SAVE IMAGE --push jalletto/circle_ci_python_example

hello:
  FROM earthly/dind:alpine
  WITH DOCKER --pull hello-world
      RUN docker run hello-world
  END