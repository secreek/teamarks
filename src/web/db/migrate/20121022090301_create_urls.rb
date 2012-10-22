class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :url
      t.string :page_title
      t.text :description

      t.timestamps
    end
  end
end
