# HerokuDbSync

Adds rake tasks to perform backup and restore between heroku remotes

Recommended git remotes setup pattern:

    $ git remote -v
    origin	git@github.com:rubynor/somecoolproject.git (fetch)
    origin	git@github.com:rubynor/somecoolproject.git (push)
    production	git@heroku.com:somecoolproject.git (fetch)
    production	git@heroku.com:somecoolproject.git (push)
    staging	git@heroku.com:somecoolproject-stage.git (fetch)
    staging	git@heroku.com:somecoolproject-stage.git (push)

## Usage

    gem 'heroku-db-sync'

    #backup production and copy to localdevelopment pg db
	rake db:sync:heroku:local

	#backup production and overwrite staging db
	rake db:sync:heroku:staging
	
	#NOTE: heroku will prompt you to confirm the name of the application that you overwrite the data for

you may also specify remotes

	rake db:sync:heroku:remote[staging,production]
	#where to_remote:staging and from_remote:production

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License

This project rocks and uses MIT-LICENSE.
