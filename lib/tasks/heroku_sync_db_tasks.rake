
namespace :heroku do
  namespace :sync do
    namespace :db do
      desc 'sync local DB with heroku. set [from_remote] to pull from other than production'
      task :local, [:from_remote, :host, :database, :username] => :environment do | task, arguments |
        HerokuDbSync::TaskHelper.perform_sync arguments.to_hash.merge({to_remote: nil})
      end

      desc 'sync staging heroku DB from production heroku DB. default from_remote=production and to_remote=staging'
      task :staging, [:from_remote] do | task, arguments |
        HerokuDbSync::TaskHelper.perform_sync arguments.to_hash.merge({to_remote: 'staging'})
      end

      desc 'sync [to_remote] heroku DB from [from_remote] heroku DB. default from_remote=production and to_remote=staging'
      task :remote, [:to_remote, :from_remote ]  do | task, arguments |
        raise "must set from_remote ('git remote' for heroku)" unless arguments[:from_remote]
        raise "must set to_remote ('git remote' for heroku)" unless arguments[:to_remote]
        HerokuDbSync::TaskHelper.perform_sync arguments
      end
    end
  end
end
