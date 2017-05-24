# README
![codeship](https://codeship.com/projects/9b28edb0-e6b6-0134-2ae0-5e565a429ea0/status?branch=master)

1. Clone to local
2. cd hireclub_web
3. Install dependencies listed below
4. Copy .env.example to .env
5. Send @kidbombay your Facebook Account ID or username to add to HireClub Test App
6. Add a user to seeds file with email matching your FB account
7. Migrate and Seed
8. foreman start

```
bundle install
bundle exec spring binstub --all
rake db:create
rake db:migrate
rake db:seed
```

Starts the server and guard to run rspec
```
foreman start -f Procfile.dev
```
Open http://localhost:3001/

* Ruby version 2.3.3

* System dependencies
Postgres
Sidekiq
Redis

* Local dependencies
Postgres - http://postgresapp.com/
Homebrew
RVM - https://rvm.io/
ImageMagick 
Terminal Notifier
Foreman

```
brew install redis
brew install terminal-notifier
brew install imagemagick
gem install foreman
```


* Configuration

Copy .env.example to .env

* Database creation

```
rake db:create
```

* Database Seed

```
rake db:seed
```

* How to run the test suite

```
rspec
```

* Update API Docs
```
rake docs:generate
```

* Rebuild Search Index
```
heroku run rake pg_search:multisearch:rebuild[Company] -r production
heroku run rake pg_search:multisearch:rebuild[User] -r production
heroku run rake pg_search:multisearch:rebuild[Project] -r production
heroku run rake pg_search:multisearch:rebuild[Job] -r production
```

Contributing
------------

Add the Heroku remote
```
heroku git:remote -a hireclub -r production
heroku git:remote -a staging-hireclub -r staging
```


-   Create a branch with the issue name
For example if the Issue is 134 Add Views Count To Invites

```
git checkout -b 134_add_views_count
```

-   Write a test case to for your issue
-   Make the minimal amount of code to make your test pass
-   Refactor
-   Write comments on any method longer than 5 lines
-   Favor readability over terse code (Don't be too clever)
-   Verify all tests pass. Guard should always be running or
```
rspec spec
```

-   Commit your code and do a pull requests. Only when all tests pass will it be accepted
-   Favor small multiple commits over large ones

* Services (job queues, cache servers, search engines, etc.)
Sidekiq handles all background jobs and mailers


* Deployment instructions
Production
```
git push production master && heroku run rake db:migrate -r production
```

* Deploy Production Branch
```
git push production +HEAD:master && heroku run rake db:migrate -r production
```


Staging
```
git push staging master && heroku run rake db:migrate -r staging
```

* Deploy Staging Branch
```
git push staging +HEAD:master && heroku run rake db:migrate -r staging
```


* Colors
https://coolors.co/6070e9-9fd356-484041-434371-79aea3
https://coolors.co/eaeef1-8783d1-8e9aaf-78c0e0-449dd1