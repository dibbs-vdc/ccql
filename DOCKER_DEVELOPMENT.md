Developing with the Docker Environment
======================================

```sh
sc up
sc be rake db:schema:load db:migrate
sc exec -s solr bin/solr create -c development -d /opt/config
```
