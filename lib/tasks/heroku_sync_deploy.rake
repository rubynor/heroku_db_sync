namespace :heroku do
  namespace :sync do
    desc "deploy to remote heroku deployment branch (git remote -v), migrate and restart"
    task :deploy_migrate, [:remote, :localbranch] do |task, arguments|
      HerokuDbSync::Deploy.deploy arguments
    end
  end
end
