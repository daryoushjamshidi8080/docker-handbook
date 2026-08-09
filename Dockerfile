FROM python:3.11.15-slim-trixie 


RUN apt-get update && apt-get install -y nano

LABEL maintainer = "daryoushjamshidi80@gmail.com"
LABEL version = "1"

WORKDIR /src 

COPY a.py /src

CMD ["python", "a.py"]

