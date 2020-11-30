# server_docker
# pyhton 3.8.4

FROM python:3.8.4

#Get web resources and requirements file
COPY ./resources/web /resources/web
COPY ./requirements.txt /requirements.txt

ENV PROJECT_HOME=/

# Install all requirements
RUN pip3 install -r /requirements.txt

# Update apt-get
RUN apt-get update
RUN apt-get install -y supervisor  

# Make predict_flask executable
CMD chmod +x /resources/web/predict_flask.py

CMD ["supervisord", "-n"]
