class ChangeDatatypeForPostInUrl < ActiveRecord::Migration
  def up
	  change_column :urls,	:poster,	:string
  end

  def down
  end
end
