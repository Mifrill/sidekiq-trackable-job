# Sidekiq::Trackable::Job

Unified solution aimed at improving monitoring and failover with TrackableJob for Sidekiq and a corresponding trackable_jobs table.

Approach outline:

When we queue one of the TrackableJobs, it inserts a record into trackable_jobs table before queuing job to the Sidekiq.
This record stores job class and model_id parameter.
That way we track when job starts and can restart them all in case of a failure, even if our Sidekiq is completely missing.
No jobs will be forgotten. trackable_jobs also has a created_at timestamp to monitor lags.

Once TrackableJob has been processed, it removes corresponding record from the trackable_jobs. 
I.e. when all jobs has been processed successfully, we have 0 trackable jobs in this table. And that’s a healthy state.

TrackableJob has a convenient method to restart all or some jobs (by ids) from this table.
That way we can easily restart jobs which, for example, were started 3 days ago and failed to complete.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sidekiq-trackable-job'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install sidekiq-trackable-job

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sidekiq-trackable-job. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/sidekiq-trackable-job/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sidekiq::Trackable::Job project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/sidekiq-trackable-job/blob/master/CODE_OF_CONDUCT.md).
