class CreateTrackableJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :trackable_jobs do |t|
      t.index %i(model_id job_class)
      t.index :created_at
      t.string :job_class, null: false
      t.string :model_id, null: false
      t.timestamps null: false
    end
  end
end
