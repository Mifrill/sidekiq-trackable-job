class TrackableJobBase
  include Sidekiq::Worker

  def initialize(*); end

  module Before
    def perform_async(id, id_type: :model_id)
      if id_type == :trackable_job_id
        trackable_job = ::TrackableJob.find(id)
        super(trackable_job.id)
      else
        ::TrackableJob.create!(job_class: name, model_id: id)
      end
    end
  end

  module After
    def perform(trackable_job_id)
      raise 'RedefinedPerformError: use job_perform(model_id) method to specify perform logic' if defined?(super)

      trackable_job = ::TrackableJob.find_with_retry(trackable_job_id)
      job_perform(trackable_job.model_id)
      trackable_job.destroy!
    end
  end

  def self.inherited(subclass)
    subclass.extend Before
    subclass.prepend After
    super
  end

  private

  def job_perform(model_id)
    raise NotImplementedError
  end
end
