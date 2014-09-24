# config valid only for Capistrano 3.1
lock '3.2.1'

# staging
set :stages, %w(staging, production)
set :default_stage, 'staging'

set :application, 'stereo_shop'
set :repo_url, 'git@github.com:Stereo-Shop/Stereo.git'

set :deploy_to, "/srv/www/#{ fetch :application }/#{ fetch :stage }"

set :unicorn_rack_env, "#{ fetch(:stage) }"
set :unicorn_pid, "#{ shared_path }/tmp/pids/unicorn.#{ fetch :stage }.pid"
set :unicorn_restart_sleep_time, 1

set :assets_roles, [:web, :app]

set :linked_files, %w{config/database.yml config/sidekiq.yml}
set :linked_dirs, %w{bin log solr tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads}

set :unicorn_config_path, "#{ shared_path }/config/unicorn.#{ fetch :stage }.rb"

set :keep_releases, 3

set :bundle_path, -> { shared_path.join('vendor/bundle') }

after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
  task :restart do
    invoke 'unicorn:legacy_restart'
  end
end
