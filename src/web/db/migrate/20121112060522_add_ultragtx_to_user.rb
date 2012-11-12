class AddUltragtxToUser < ActiveRecord::Migration
  def change
  	u = User.new
    u.email = 'ultragtx@gmail.com'
    u.username = 'Guo Xinrong'
    u.password = 'pwd'
    u.save
  end
end
