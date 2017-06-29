FROM ruby:2.4.0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs && apt-get clean

ADD https://downloads.wkhtmltopdf.org/0.12/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz /wkhtmltopdf.tar.xz
RUN tar -xvf wkhtmltopdf.tar.xz
RUN mv /wkhtmltox/bin/wkhtmltopdf /usr/bin

WORKDIR /usr/src/app

ENV BUNDLE_PATH /ruby_gems

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
