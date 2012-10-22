class AddUserToUrl < ActiveRecord::Migration
  def change
    add_column :urls, :poster, :url
  end
end
