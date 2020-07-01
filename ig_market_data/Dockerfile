FROM python:3.7-alpine
COPY requirements.txt /
RUN pip install -r /requirements.txt
COPY lightstreamer.py /ig_market_data/lightstreamer.py
WORKDIR /ig_market_data
ENTRYPOINT ["python3"]
CMD ["lightstreamer.py"]