FROM python:3.9-alpine3.16

WORKDIR /app
COPY /crawler requirements.txt /app/

RUN apk --no-cache --update add build-base && \
    pip install --upgrade pip && \
    pip install -r /app/requirements.txt && \
    apk del build-base && \
    pip cache purge

ENV MONGO mongo
ENV MONGO_PORT 27017
ENV RMQ_HOST rmq
ENV RMQ_QUEUE urls
ENV RMQ_USERNAME quest
ENV RMQ_PASSWORD quest
ENV CHECK_INTERVAL 60
ENV EXCLUDE_URLS .*github.com
ENV URL https://vitkhab.github.io/search_engine_test_site/

CMD ["sh", "-c", "python crawler.py $URL"]
