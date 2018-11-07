Developing with the Docker Environment
======================================

```sh
sc up
sc be rake db:schema:load db:migrate db:seed
```

## Running the test suite

To setup the Solr core for the test suite, do:

```sh
sc exec -s solr bin/solr create -c hyrax-test -d /opt/config
```

Then you can run tests with:

```sh
sc be rspec
```
