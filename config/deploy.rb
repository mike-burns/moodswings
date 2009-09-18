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
end
