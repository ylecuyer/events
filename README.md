[![Travis](https://img.shields.io/travis/ylecuyer/events.svg)]()
[![VersionEye](https://img.shields.io/versioneye/d/user/projects/593b69d9368b08004e5145bb.svg)]()
[![Code Climate](https://img.shields.io/codeclimate/github/ylecuyer/events.svg)]()
[![Code Climate](https://img.shields.io/codeclimate/coverage/github/ylecuyer/events.svg)]()
[![license](https://img.shields.io/github/license/ylecuyer/events.svg)]()

# Events

Free & open-source invitation and event management platform. 🎫

Mainly inspired by [Attendize](https://github.com/Attendize/Attendize)

## How to run with docker 🐳

Clone the project

    git clone git@github.com:ylecuyer/events.git
    
Build the docker containers

    cd events
    docker-compose build
    
Install gems

    docker-compose run app bundle install

Setup database

    docker-compose run app bundle exec rake db:setup

Configure the API keys
    
    cp app/application.yml.example app/application.yml
    vim app/application.yml

Run

    docker-compose up
    
Then go to 
 * [http://localhost:3000](http://localhost:3000) (login: ```user@example.com```, password: ```changeme```)

## Run tests

Run

    docker-compose run app bundle exec rails test test/

## Deploy

Run

    eval $(ssh-agent)
    ssh-add ~/.ssh/id_rsa
    cap production deploy

## What is included?

 * WYSIWYG editor for the invitation mail models
 * PDF ticket generator with QR Code
 * Highly integrated with [mailgun](https://www.mailgun.com/) (delivery receipts, mass sending)
 * SPAM score indicator
 * Live stats
 * Invitation QR Code can be read with any QR Code reader
 
## License

[GPL v3](https://github.com/ylecuyer/events/blob/master/LICENSE.txt)
 
