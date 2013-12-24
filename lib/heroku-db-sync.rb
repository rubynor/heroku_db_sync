require 'heroku-db-sync/task_helper'
require 'heroku-db-sync/deploy_and_migrate'

module HerokuDbSync

  class HerokuDbSyncTask < Rails::Railtie
    rake_tasks do
      Dir[File.join(File.dirname(__FILE__),'tasks/*.rake')].each { |f| load f }
    end
  end

end
