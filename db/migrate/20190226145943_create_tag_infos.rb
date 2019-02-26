class CreateTagInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :tag_infos do |t|
      t.string :tag_key
      t.string :tag_value

      t.timestamps
    end
  end
end
