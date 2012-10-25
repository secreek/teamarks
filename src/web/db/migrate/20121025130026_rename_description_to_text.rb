class RenameDescriptionToText < ActiveRecord::Migration
  def up
    rename_column :urls, :description, :text
  end

  def down
  end
end
