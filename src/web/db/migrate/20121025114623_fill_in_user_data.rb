class FillInUserData < ActiveRecord::Migration
  def change
    # User One
    u = User.new
    u.email = 'hf@zhanghongfeng.com'
    u.username = 'Zhang HF'
    u.password = 'pwd'
    u.save

    # User Two
    u = User.new
    u.email = 'cliffwoo@gmail.com'
    u.username = 'Cliff Woo'
    u.password = 'pwd'
    u.save

    # User Three
    u = User.new
    u.email = 'admin@mtday.com'
    u.username = 'Hailong Geng'
    u.password = 'pwd'
    u.save

    # User Four
    u = User.new
    u.email = 'voidmain1313113@gmail.com'
    u.username = 'VoidMain'
    u.password = 'pwd'
    u.save
  end
end
