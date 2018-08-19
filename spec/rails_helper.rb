# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'database_cleaner'

spec = File.dirname(__FILE__)

Dir["#{spec}/shared/**/*.rb"].each(&method(:require))

Dir["#{spec}/support/**/*.rb"].each(&method(:require))

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner[:active_record].strategy = :transaction
    DatabaseCleaner[:active_record].clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner[:active_record].cleaning do
      example.run
    end
  end

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end
