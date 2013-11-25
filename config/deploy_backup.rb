require "bundler/capistrano"
require "sidekiq/capistrano"

server "173.255.193.26", :web, :app, :db, primary: true

set :application, "anotherfailedstartup.com"
set :user, "deploy"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "https://rafaelfragosom:81980684ra@github.com/Gennovacap-Technology/tpavc.git"
set :branch, "deployment"

require "rvm/capistrano"
set :rvm_ruby_string, 'ruby-2.0.0-p247@global'
set :rvm_type, :user

# Configuration for the RVM
set :default_environment, {
  'PATH' => "/home/deployer/.rvm/gems/ruby-2.0.0-p247@global/bin:/home/deploy/.rvm/bin:/home/deploy/.rvm/rubies/ruby-2.0.0-p247/bin:$PATH",
  'RUBY_VERSION' => 'ruby-2.0.0-p247',
  'GEM_HOME'     => '/home/deploy/.rvm/gems/ruby-2.0.0-p247@global',
  'GEM_PATH'     => '/home/deploy/.rvm/gems/ruby-2.0.0-p247@global',
  'BUNDLE_PATH'  => '/home/deploy/.rvm/gems/ruby-2.0.0-p247@global'  # If you are using bundler.
}

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do

  task :setup_config, roles: :app do
    #sudo "ln -nfs #{current_path}/config/nginx.conf /opt/nginx/sites-available/#{application}"
    #sudo "ln -nfs #{current_path}/config/nginx.conf /opt/nginx/sites-enabled/#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.original.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/deployment`
      puts "WARNING: HEAD is not the same as origin/deployment"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"


end