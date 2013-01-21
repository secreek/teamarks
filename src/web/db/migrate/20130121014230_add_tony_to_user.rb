class AddTonyToUser < ActiveRecord::Migration
  def change
  	u = User.new
    u.email = 'zhutaoisme@gmail.com'
    u.username = 'Zhu Tao'
    u.password = 'pwd'
    u.save
  end
end
