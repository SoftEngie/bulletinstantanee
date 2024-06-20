FROM python:3.11.4-slim-buster

RUN mkdir -p /home/app
RUN addgroup --system app && adduser --system --group app

ENV HOME=/home/app
ENV APP_HOME=/home/app/web
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip install pipenv
COPY Pipfile Pipfile.lock .
RUN pipenv install --dev --system --deploy




COPY ./webapp_entrypoint.sh .

RUN sed -i 's/\r$//g'  $APP_HOME/webapp_entrypoint.sh
RUN chmod +x  $APP_HOME/webapp_entrypoint.sh

COPY .  $APP_HOME/
RUN chown -R app:app $APP_HOME
USER app

ENTRYPOINT ["/home/app/web/webapp_entrypoint.sh"]
