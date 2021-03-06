# Behold!
# https://gorails.com/deploy/ubuntu/14.04

# config valid only for current version of Capistrano
#lock '3.4.0'

set :application, 'shipping'
set :repo_url, 'git@github.com:tyrant/shipping.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/app-user/shipping'

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
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
#set :linked_dirs, %{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# http://stackoverflow.com/questions/34126546
set :rbenv_path, '/home/app-user/.rbenv'

namespace :deploy do

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc "Make a secrets.yml symlink"
  task :copy_secrets do
    on roles(:app), in: :sequence, wait: 5 do
      # Capistrano already makes a symlink to database.yml in the /shared/config directory; Rails
      # requires secrets.yml too.
      execute 'ln ~/shipping/shared/config/secrets.yml ~/shipping/current/config/secrets.yml'
    end
  end

  after :publishing, 'deploy:restart'
  after :publishing, 'deploy:copy_secrets'
  after :finishing, 'deploy:cleanup'

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
