FROM alpine

RUN apk add --update curl jq

ADD https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip ./ngrok.zip
RUN unzip ngrok.zip
RUN rm ngrok.zip

COPY ngrok.yml .

EXPOSE 4040

ADD ./entrypoint.sh .

ENTRYPOINT ./entrypoint.sh
