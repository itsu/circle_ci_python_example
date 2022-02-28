VERSION 0.6
FROM python:3
WORKDIR /circle_ci_python_example

test-and-lint:
  COPY . .
  COPY docker-compose.yml ./ 
  WITH DOCKER 
      DOCKER PULL postgres:14.1
      DOCKER PULL python:latest
      RUN docker-compose up -d 
  END

build:
	COPY . /circle_ci_python_example
  RUN pip install -r requirements.txt
  COPY . /circle_ci_python_example/
	SAVE ARTIFACT circle_ci_python_example AS LOCAL circle_ci_python_example

docker-hub:
	FROM +build
	EXPOSE 8000
	CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
	SAVE IMAGE jalletto/circle_ci_python_example:latest


FROM python:3
WORKDIR 


