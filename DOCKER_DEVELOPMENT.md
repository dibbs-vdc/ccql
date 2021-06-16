Developing with the Docker Environment
======================================
## 1. Encrypting and Decrypting .env.development

To be able to pass encypted env values among the Notch8 team we must encypt/decrypt .env.development. This file contains API keys needed for browse-everything to work as well as environment variables required by the globus export feature.
### Decrypting
`keybase decrypt -i .env.development.enc -o .env.development`

### Encrypting
`keybase encrypt -i .env.development -o .env.development.enc --team notch8.rutgersvdc`

## 2. Starting up your container

```sh
sc up
sc be rake db:create db:schema:load db:migrate db:seed
```

## 3. Running the test suite

To setup the Solr core for the test suite, do:

```sh
sc exec -s solr bin/solr create -c hyrax-test -d /opt/config
```

Then you can run tests with:

```sh
sc be rspec
```

## 4. Creating new works / file uploads

To be able to successfully upload files, Sidekiq needs to be running to process the background jobs:

```sh
sc be sidekiq
```

To be able to successfully create a work, you need to set up a depositor:

1. Sign in as an admin
2. Navigate the the 'Manage Registered Users' tab in the Dashboard
3. Click 'Create Person' under the Operations Label column adjacent to the user you want to be able to deposit works
4. Select the name of that user when depositing a new work
5. Profit
