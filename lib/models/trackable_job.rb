class TrackableJob < ApplicationRecord
  validates :job_class, :model_id, presence: true

  # https://github.com/mperham/sidekiq/wiki/Problems-and-Troubleshooting#cannot-find-modelname-with-id12345
  after_create_commit :perform_async

  def perform_async
    job_class.constantize.perform_async(id, id_type: :trackable_job_id)
  end
end
