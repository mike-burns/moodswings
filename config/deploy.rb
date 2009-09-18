default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :application, "moodswings"

set :repository,  "git@github.com:mike-burns/moodswings.git"
set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache

set :deploy_to, "/usr/home/mike/#{application}"
set :user, "mike"

role :app, "moodswin.gs"
role :web, "moodswin.gs"
role :db,  "moodswin.gs", :primary => true

namespace :deploy do
  desc "Default deploy - updated to run migrations"
  task :default do
    set :migrate_target, :latest
    update_code
    migrate
    symlink
    symlink_db_config
    restart
  end

  desc "Run this after every successful deployment" 
  task :after_default do
    cleanup
  end

  %w(start stop restart).each do |action|
    desc "#{action} the Thin server"
    task action.to_sym, :roles => :app do
      run "thin #{action} -c #{deploy_to}/current -C /usr/local/etc/thin/#{application}.conf"
    end
  end

  desc "Use the database.yml that knows the prod password"
  task :symlink_db_config do
    run "rm -f #{current_path}/config/database.yml && ln -s #{shared_path}/database.yml #{current_path}/config/database.yml"
  end
end
