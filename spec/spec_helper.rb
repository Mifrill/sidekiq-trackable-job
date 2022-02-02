require "sidekiq/testing"
require "sidekiq/trackable_job"
require "faker"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
  ActiveRecord::Schema.verbose = false

  config.before(:all) do
    migration = ActiveRecord::Migration.new
    migration.verbose = false
    migration.create_table :trackable_jobs do |t|
      t.index %i[model_id job_class]
      t.index :created_at
      t.string :job_class, null: false
      t.string :model_id, null: false
      t.timestamps null: false
    end
  end

  config.after(:all) do
    migration = ActiveRecord::Migration.new
    migration.verbose = false
    migration.drop_table :trackable_jobs
  end
end
