class CreateSegmentations < ActiveRecord::Migration[5.0]
  def change
    create_table :segmentations do |t|
      t.string :title
      t.string :description
      t.string :query
      t.string :parameters

      t.timestamps
    end
  end
end
