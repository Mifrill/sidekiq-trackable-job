describe TrackableJobBase do
  class ChildJob < TrackableJobBase
    private

    def job_perform(*)
      # your logic here
    end
  end

  subject { ChildJob.new }

  let(:model) { OpenStruct.new(id: Faker::Number.number(digits: 1)) }
  let(:job_instance) { subject }
  let(:job_class) { subject.class }
  let(:model_id) { model.id }

  describe ".perform_async" do
    it { expect { job_class.perform_async(model_id) }.to change { TrackableJob.count }.by(1) }
    it { expect { job_class.perform_async(model_id) }.to change { job_class.jobs.count }.by(1) }
  end

  describe "#perform" do
    let(:trackable_job) { create(:trackable_job, job_class: job_class, model_id: model_id) }

    it "raises RedefinedPerformError when method perform is redefined by child job" do
      class TrackTestPerformErrorJob < TrackableJobBase
        def perform(*); end
      end

      error = "RedefinedPerformError: use job_perform(model_id) method to specify perform logic"
      expect { TrackTestPerformErrorJob.new.perform(trackable_job.id) }.to raise_exception(error)
    end

    it "raises NotImplementedError when method job_perform is not defined" do
      class TrackTestImplementedErrorJob < TrackableJobBase; end

      expect { TrackTestImplementedErrorJob.new.perform(trackable_job.id) }.to raise_exception(NotImplementedError)
    end

    it "removes TrackableJob after success perform" do
      trackable_job_id = trackable_job.id
      expect { job_instance.perform(trackable_job_id) }.to change { TrackableJob.count }.by(-1)
    end

    it "does the second attempt find to resolve replica lag for recently created record" do
      call_count = 0
      trackable_job_id = trackable_job.id
      expect(::TrackableJob).to receive(:find).with(trackable_job.id) do
        call_count += 1
        call_count == 1 ? (raise ActiveRecord::RecordNotFound) : trackable_job
      end.twice
      job_instance.perform(trackable_job_id)
    end
  end

  describe "perform_async with id_type trackable_job_id" do
    let!(:trackable_job) { create(:trackable_job, job_class: job_class, model_id: model_id) }

    it "does not create another one trackable_job" do
      expect { job_class.perform_async(trackable_job.id, id_type: :trackable_job_id) }
        .not_to change { TrackableJob.count }
    end

    it "creates sidekiq_job" do
      expect { job_class.perform_async(trackable_job.id, id_type: :trackable_job_id) }
        .to change { job_class.jobs.count }.by(1)
    end
  end
end
