describe Sidekiq::TrackableJob::Model do
  describe "#perform_async" do
    class TestJob
      def self.perform_async(*); end
    end

    it "creates job" do
      restart_job = Sidekiq::TrackableJob::Model.create!(job_class: TestJob, model_id: Faker::Number.number(digits: 10))
      expect(restart_job.job_class.constantize)
        .to receive(:perform_async).with(restart_job.id, id_type: :trackable_job_id)
      restart_job.perform_async
    end
  end

  describe ".after_create_commit" do
    class TestSidekiqJob
      include Sidekiq::Worker
    end

    it "calls #perform_async on create" do
      expect_any_instance_of(described_class).to receive(:perform_async)
      Sidekiq::TrackableJob::Model.create!(job_class: TestSidekiqJob, model_id: Faker::Number.number(digits: 10))
    end
  end
end
