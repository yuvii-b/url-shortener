FROM alpine:latest

RUN apk add --no-cache g++ make sqlite-dev boost-dev asio-dev

WORKDIR /app

COPY . .

RUN make server
RUN make frontend
RUN make 

RUN chmod +x start.sh

CMD ["./start.sh"]