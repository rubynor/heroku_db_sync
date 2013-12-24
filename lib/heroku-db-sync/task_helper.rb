
module HerokuDbSync

  module TaskHelper
    def self.perform_sync arguments
      Bundler.with_clean_env do
        @arguments = arguments
        from_remote = arguments[:from_remote] || 'production'
        to_remote = arguments[:to_remote]

        puts "(1/4) capturing #{from_remote} database snapshot..."
        run "heroku pgbackups:capture --expire --remote #{from_remote}"

        if to_remote
          puts "(2/4) fetching backup url from remote #{from_remote}"
          backup_url = runr("heroku pgbackups:url --remote #{from_remote}")
          print "(3/4) backing up #{to_remote} and restoring it from snapshot from #{from_remote} ... "
          run "heroku pgbackups:capture --expire --remote #{to_remote}"
          puts "captured. restoring .."
          restore_cmd = "heroku pgbackups:restore DATABASE '#{backup_url}' --remote #{to_remote}"
          puts restore_cmd
          run restore_cmd   # use 'system' as heroku prompts for confirmation of db restore.
          puts "(4/4) restarting remote #{to_remote}"
          run "heroku restart --remote #{to_remote}"
        else
          dumpfile = 'latest.dump'
          puts "(2/4) downloading snapshot..."
          run "curl -o #{dumpfile} \`heroku pgbackups:url --remote #{from_remote}\`"
          puts "(3/4) restoring snapshot to #{host} database #{database} ... "
          `pg_restore --verbose --clean --no-acl --no-owner -h #{host} -U #{user} -d #{database} #{dumpfile}`
          keep = arguments[:keepdump] || false
          unless keep
            puts "(4/4) cleaning up..."
            `rm #{dumpfile}`
          else
            puts "(4/4) keeping #{dumpfile}"
          end
        end

puts "Success! Ah, that was exhausting, pop a beer!"
      end
    end

    def self.host
      @arguments[:host] || db_config[:host] || raise("no host configured")
    end

    def self.user
      @arguments[:username] || db_config[:username] || raise("no user configured")
    end

    def self.database
      @arguments[:database] || db_config[:database]  || raise("no database configured")
    end

    def self.db_config
      @_db_config ||= Rails.configuration.database_configuration[Rails.env].with_indifferent_access
    end

  private
    # Execute commands using system. This command returns true or false if it was a success.
    # system() also allows prompts to be shown. This is needed for the restore command, heroku asks the user to type the application name
    def self.run command
      system(command) || raise("ERROR running < #{command} >. Look above for details")
    end

    # Execute command using ` `. This returns the result as a string, empty if it failed.
    def self.runr command
      res = `#{command}`.strip
      res.empty? ? raise("ERROR running < #{command} >. Empty result. Look above for details") : res
    end
  end
end
