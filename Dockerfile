FROM python:3
WORKDIR /circle_ci_python_example
COPY . /circle_ci_python_example
RUN pip install -r requirements.txt
COPY . /circle_ci_python_example/
EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
