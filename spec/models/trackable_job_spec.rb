describe TrackableJob do

  describe '#perform_async' do
    class TestJob
      def self.perform_async(*); end
    end

    it 'creates job' do
      restart_job = create(:trackable_job, job_class: TestJob)
      expect(restart_job.job_class.constantize).
        to receive(:perform_async).with(restart_job.id, id_type: :trackable_job_id)
      restart_job.perform_async
    end
  end

  describe '.after_create_commit' do
    class TestSidekiqJob
      include Sidekiq::Worker
    end

    it 'calls #perform_async on create' do
      expect_any_instance_of(described_class).to receive(:perform_async)
      create(:trackable_job, job_class: TestSidekiqJob)
    end
  end
end
