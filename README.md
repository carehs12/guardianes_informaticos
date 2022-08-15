# Guardianes Informáticos

Guardianes Informáticos - Technical Exam

* Ruby version

  This project was created using ruby *2.7.2* and rails *7.0.2*.
  You need to have the correct version of ruby installed in order to run it.
  To read more about how you can install ruby, it is advisable to use a ruby
  version management tool, like **RVM**. You can read more about RVM here:
  https://rvm.io/

* Installing Gems

  Once Ruby has been installed, you can clone this repo and run the command

  ```console
    bundle install
  ```

  This will install all gems required for the application to work. If at some
  point, you want to update your gems to the newer versions, you can run

  ```console
    bundle update
  ```

* Configuration

  You must edit you config/credentials.yml by running the following command:
  ```console
    EDITOR="YOUR_FAVORITE_EDITOR" rails credentials:edit 
  ```

  If you are using an editor like Visual Studio Code, or Sublime, you probably will need to add an extra command:
  ```console
    EDITOR="YOUR_FAVORITE_EDITOR" --wait rails credentials:edit
  ```

  Please make sure that the credentials are configured as shown in this example for the 
  application to work property:

  ```yml
  # You can set only the environtment you are using
  db:
    development:
      endpoint: YOUR_DEV_ENDPOINT
      database: YOUR_DB_NAME
      username: YOUR_DB_USER_NAME
      password: YOUR_DB_USER_PASSWORD
    test:
      endpoint: YOUR_TEST_ENDPOINT
      database: YOUR_DB_NAME
      username: YOUR_DB_USER_NAME
      password: YOUR_DB_USER_PASSWORD
    production:
      endpoint: YOUR_PRODUCTION_ENDPOINT
      database: YOUR_DB_NAME
      username: YOUR_DB_USER_NAME
      password: YOUR_DB_USER_PASSWORD
  smtp:
    # You can use letter_opener or a similar gem for development
    # and another service like SES for production
    delivery_method: YOUR_DELIVERY_METHOD
  # Use this only if you are using SES as SMTP delivery method 
  # and/or S3 as storage service.
  # You can read how to configure S3 here
  # https://edgeguides.rubyonrails.org/active_storage_overview.html
  aws:
    s3: 
      access_key_id: YOUR_S3_ACCESS_KEY_ID
      secret_access_key: YOUR_S3_SECRET_ACCESS_KEY
      region: YOUR_S3_REGION
      bucket: YOUR_S3_BUCKET
    ses:
      access_key_id: YOUR_SES_ACCESS_KEY_ID
      secret_access_key: YOUR_SES_SECRET_ACCESS_KEY

  secret_key_base: A_VERY_LONG_STRING_USED_AS_BASE_FOR_MESSAGEVERIFIERS_IN_RAILS
  ```

* Database creation

  The application uses postgres as database engines. For it to work, you need
  to have a postgreSQL client installed into your computer, and have access
  to a computer that has a postgreSQL server installed. Please note that you can
  install both the PostgreSQL server and client inside the same computer and run
  the application like that. To install postgreSQL, you can check the following link:
  https://www.postgresql.org/download/

* Database initialization

  Once your database is created and your credentials are set, you can set up your database using
  ```console
    rails db:create
    rails db:migrate
    rails db:seeds
  ```

  If you don't specify the environment, rails will default to **development**. However, 
  you can change this behavior by specifying the environment
  ```console
    rails db:create RAILS_ENV=test
  ```

  In the repository, only one development user is created: **chermosilla** with
  password **recorrido123**. You can add more users editing the *db/seeds/ENVIRONMENT.rb"
  file

  Alternatively, you can condense the whole setup of the database running
  ```console
    rails db:setup
  ```

* How to run the test suite

The tests for this application were created using *FactoryBot* and *rspec*. 
The gem is installed by default when the environments are **development** and production**.

In order to run the test suite. You neet to execute the following commands:

```console
  # Note that the credentials for the test database MUST be configured.
  rails db:setup RAILS_ENV=test
  rspec
```

This will execute all tests and output the result

* Deployment instructions

* Algorithm Explanation

* ...
