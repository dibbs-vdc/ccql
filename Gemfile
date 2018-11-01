source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'hyrax', '~> 2.1'
gem 'rails', '~> 5.1.6'

gem 'byebug', platform: :mri, group: %i[development test]
gem 'capybara', group: %i[development test]
gem 'capybara-screenshot', group: %i[test]
gem 'coffee-rails', '~> 4.2'
gem 'database_cleaner', group: %i[development test]
gem 'devise'
gem 'devise-guests', '~> 0.6'
gem 'factory_bot_rails', group: %i[development test]
gem 'fcrepo_wrapper', group: %i[development test]
gem 'hyrax-spec', '~> 0.3', group: %i[development test]
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'launchy', group: %i[test]
gem 'listen', '~> 3.0.5', group: %i[development]
gem 'omniauth-shibboleth'
gem 'pry-rails', group: %i[development test]
gem 'puma', '~> 3.0'
gem 'redis', '~> 3.0'
gem 'rsolr', '>= 1.0'
gem 'rspec-rails', group: %i[development test]
gem 'sass-rails', '~> 5.0'
gem 'solr_wrapper', '>= 0.3', group: %i[development test]
gem 'spring', group: %i[development]
gem 'spring-watcher-listen', '~> 2.0.0', group: %i[development]
gem 'sqlite3'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'web-console', '>= 3.3.0', group: %i[development]
