# frozen_string_literal: true

RSpec.describe Sidekiq::Trackable::Job do
  it "has a version number" do
    expect(Sidekiq::Trackable::Job::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
