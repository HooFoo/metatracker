# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'metatracker'
set :repo_url, 'git@github.com:HooFoo/metatracker.git'
set :shared_path, '~/metatracker/shared'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '~/metatracker'
set :puma_threads,    [4, 16]
set :puma_workers,    1

set :stage,           :production
set :deploy_via,      :remote_cache
set :pty,             true
set :use_sudo,        false
set :puma_bind,       "unix://#{shared_path}/sockets/puma.sock"
set :puma_conf,       "#{shared_path}/puma.rb"
set :puma_state,      "#{shared_path}/pids/puma.state"
set :puma_pid,        "#{shared_path}/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :linked_files, %w{ config/secrets.yml .env}

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart

  desc "Restart  app"
  task :restart do
  end

  after :restart, :clear_cache do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

end
