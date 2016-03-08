set(:branch, "master")
set :deploy_host, "vk215946553.myihor.ru"
set :repository, "git@github.com:HooFoo/metatracker.git"
set :stage, :production
set :rails_env, "production"
set :user, 'hoofoo'
set :use_sudo, false


server "185.125.218.102", roles: [:app, :web, :db], primary: true
