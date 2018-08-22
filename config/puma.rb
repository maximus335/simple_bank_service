# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

env_value = proc do |name, default|
  value = ENV[name]
  value.blank? ? default : value
end

port ENV.fetch('SBS_PORT') { 8029 }

puma_workers     = env_value['SBS_PUMA_WORKERS', 4]
puma_threads_min = env_value['SBS_PUMA_THREADS_MIN', 0]
puma_threads_max = env_value['SBS_PUMA_THREADS_MAX', 5]

workers puma_workers
threads puma_threads_min, puma_threads_max

puma_env = ENV['RAILS_ENV'] || 'development'

environment puma_env

preload_app!

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    config = ActiveRecord::Base.configurations[Rails.env] ||
        Rails.application.config.database_configuration[Rails.env]
    ActiveRecord::Base.establish_connection(config)
  end
end
