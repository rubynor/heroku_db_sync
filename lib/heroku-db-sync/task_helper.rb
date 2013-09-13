
module HerokuDbSync
  module TaskHelper
    def self.perform_sync arguments
      @arguments = arguments
      from_remote = arguments[:from_remote] || 'production'
      to_remote = arguments[:to_remote]

      puts "(1/4) capturing #{from_remote} database snapshot..."
      `heroku pgbackups:capture --expire --remote #{from_remote}`

      if to_remote
        puts "2/4 fetching backup url from remote #{from_remote}"
        backup_url = `heroku pgbackups:url --remote #{from_remote}`
        puts "(3/4) backing up #{to_remote} and restoring it to snapshot from #{from_remote} ... "
        `heroku pgbackups:capture --expire --remote #{to_remote}`
        restore_cmd = "heroku pgbackups:restore DATABASE '#{backup_url}' --remote #{to_remote}"
        puts restore_cmd
        system(restore_cmd)   # use 'system' as heroku prompts for confirmation of db restore.
        puts "(4/4) restarting remote #{to_remote}"
        `heroku restart --remote #{to_remote}`
      else
        dumpfile = 'latest.dump'
        puts "(2/4) downloading snapshot..."
        `curl -o #{dumpfile} \`heroku pgbackups:url --remote #{from_remote}\``
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
  end
end
