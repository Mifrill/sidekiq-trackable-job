require_relative "lib/sidekiq/trackable/job/version"

Gem::Specification.new do |spec|
  spec.name          = "sidekiq-trackable-job"
  spec.version       = Sidekiq::Trackable::Job::VERSION
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
end
