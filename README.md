# ccql
ccql is a [Hyrax](https://github.com/samvera/hyrax)-based Ruby on Rails application for cataloging, committing, querying, and linking data related to the DIBBS Virtual Data Collaboratory (VDC) project.

The application is being built as part of the Dibbs Project. More information about the project can be found here:

* https://www.cs.rutgers.edu/news/4-million-dibbs-grant-awarded
* https://www.libraries.rutgers.edu/news/rutgers-receives-4-million-grant-nsf-establish-regional-data-sharing-network

More information about Hyrax can be found here:

* http://samvera.github.io
* https://github.com/samvera/hyrax

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. Until this document is fleshed out better, please see the Samvera Hyrax project documentation to get the prerequisites for a Hyrax-based application set up first.

### Some Prerequisites

* Solr (development with 6.6.1)
* Fedora (development with 4.7.1)
* Apache (for Shibboleth)
* Redis
* Fits
* Shibboleth requires registration of application
* sqlite3

Please note that development of this application is currently on CentOS 7. We are currently using Hyrax Gem 1.0.4.

### Running your dev environment

Eventually, we'll have a step by step series of examples that describe how to get a development env running. For now, here are some useful steps.

#### Solr

```
$ solr_wrapper -p 8983 -i tmp/solr-development -d solr/config -n hydra-development --version=7.1.0
```

Note: I don't understand Solr that well yet. With this wrapper, I sometimes need to stop Solr prior to running. Until I understand things better, here's what I usually do for that: 

```
$ sudo service solr status
$ sudo service solr stop
$ solr_wrapper -p 8983 -i tmp/solr-development -d solr/config -n hydra-development --version=7.1.0
```

Also, weird things happen when I attempt to try 7.2.0.

#### Redis

```
$ sudo systemctl start redis.service
```

#### Fedora 4

```
$ fcrepo_wrapper -p 8984 --no-jms -d tmp/fcrepo4-development-data
```

#### Running this application

Run the following commands to get the Rails application running on localhost:3000. Before running it for the first time, look up the setup notes: https://github.com/dibbs-vdc/ccql/wiki/Setup--Notes

```

$ bundle install
$ bin/rails db:migrate RAILS_ENV=development
$ RAILS_ENV=development rake hyrax:default_admin_set:create
$ RAILS_ENV=development rake hyrax:workflow:load
$ RAILS_ENV=development rails server

```

#### Additional Steps

[Setting Up Your First Admin User](https://github.com/dibbs-vdc/ccql/wiki/Setting-Up-Your-First-Admin-User)

## Contributing

We'd love contributors! Please contact us for more information. At this time, we don't have a formal process to contribute, but we're working towards that.

## License

This project is licensed under the Apache 2.0. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

In building this application, we received a LOT of help from Rutgers, PSU, Temple University, and the whole Samvera community. Thanks!
