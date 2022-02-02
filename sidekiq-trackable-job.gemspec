require_relative "lib/sidekiq/trackable_job"

Gem::Specification.new do |spec|
  spec.name          = "sidekiq-trackable-job"
  spec.version       = Sidekiq::TrackableJob::VERSION
  spec.authors       = ["Aleksei Strizhak", "Andrey Zharikov"]
  spec.email         = %w[alexei.mifrill.strizhak@gmail.com andrey@zharikov.pro]

  spec.summary       = "Track when the job starts and can restart them all in case of a failure."
  spec.description   = "Store data of the starts (queuing) and ends (finishes properly) of sidekiq job in the relation DB, in case of failures."
  spec.homepage      = "https://github.com/Mifrill/sidekiq-trackable-job.git"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/Mifrill/sidekiq-trackable-job/blob/master/CHANGELOG.md"

  spec.require_paths = ["lib"]
  spec.files         = Dir["{lib}/**/*"] + %w[LICENSE.txt]
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.add_runtime_dependency "activerecord"
  spec.add_runtime_dependency "sidekiq"

  spec.add_development_dependency "byebug"
  spec.add_development_dependency "faker"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "rspec-sidekiq"
  spec.add_development_dependency "sqlite3"
end
