FROM python:3.8-slim
WORKDIR /APP
COPY . /APP
RUN pip install -r requirements.txt
RUN apt-get update
RUN apt-get -y install libgl1-mesa-glx
RUN apt-get update
RUN apt-get -y install libglib2.0-0
CMD python ./app.py
