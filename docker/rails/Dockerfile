FROM ruby:2.4.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs && apt-get clean

ADD https://downloads.wkhtmltopdf.org/0.12/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz /wkhtmltopdf
RUN mv /wkhtmltopdf/wkhtmltox/bin/wkhtmltopdf /usr/bin

WORKDIR /usr/src/app

ENV BUNDLE_PATH /ruby_gems
ENV SPRING_TMP_PATH tmp
ENV SPRING_SOCKET tmp/spring.sock
ENV SPRING_PIDFILE tmp/spring.pid

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
