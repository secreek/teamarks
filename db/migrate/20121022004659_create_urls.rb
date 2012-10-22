class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
	  t.string	:url
	  t.string	:page_title
	  t.text	:selected_text
	  t.references :user
      t.timestamps
    end
  end
end
