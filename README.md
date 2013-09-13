# HerokuDbSync

Adds rake tasks to perform backup and restore between heroku remotes

## Usage

    gem 'heroku-db-sync'

    #backup production and copy to localdevelopment pg db
	rake db:sync:heroku:local

	#backup production and overwrite staging db
	rake db:sync:heroku:staging

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
