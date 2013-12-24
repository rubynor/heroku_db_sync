module HerokuDbSync
  module Deploy

    def self.deploy arguments
      Bundler.with_clean_env do
        remote = arguments[:remote]
        raise "must specify git remote. 'production' 'staging' or 'heroku'" unless remote
        branch = arguments[:localbranch] || 'master'

        execute "git push #{remote} #{branch}:master"
        execute "heroku run rake db:migrate --remote #{remote}"
        execute "heroku restart --remote #{remote}"
        puts "\nSUCCESS. Go to your web site for a paranoid sanity check.\nPop a beer\n"
      end
    end

    def self.execute(cmd)
      puts "===================================================\nExecuting: #{cmd}\n==================================================="
      system(cmd) || raise("\n FAILED  FAILED  FAILED  FAILED \n handle manually!\n Server may be down. Don't panic, remember your towel\n\n========")
    end

  end
end
