FROM python:latest

LABEL maintainer ="daryoushjamshidi80@gmail.com"
LABEL github="https://github.com/daryoushjamshidi8080"


WORKDIR /code 

RUN pip install --no-cache-dir -U pip

COPY requirements.txt /code/
RUN pip install --no-cache-dir -r requirements.txt

COPY . /code/

EXPOSE 8000

CMD ["gunicorn", "A.wsgi:application", "--bind", "0.0.0.0:8000"]

