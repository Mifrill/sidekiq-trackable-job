require "active_record"

module Sidekiq
  module TrackableJob
    class Model < ActiveRecord::Base
      self.table_name = :trackable_jobs

      def self.find_with_retry(id)
        attempts ||= 0
        find(id)
      rescue ActiveRecord::RecordNotFound => e
        attempts += 1
        raise e if attempts >= 3

        retry
      end

      validates :job_class, :model_id, presence: true

      # https://github.com/mperham/sidekiq/wiki/Problems-and-Troubleshooting#cannot-find-modelname-with-id12345
      after_create_commit :perform_async

      def perform_async
        job_class.constantize.perform_async(id, id_type: :trackable_job_id)
      end
    end
  end
end
