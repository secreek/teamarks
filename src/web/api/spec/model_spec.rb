require_relative "spec_helper"

describe 'user' do
  before(:each) do
    @user = User.new(claimed_id: 'http://www.google.com',
      nickname: 'voidmain',
      email: 'voidmain1313113@gmail.com',
      created_at: Time.now,
      updated_at: Time.now)
  end

  specify 'should be valid' do
    @user.should be_valid
  end

  specify 'should require a name' do
    u = User.new
    u.should_not be_valid
  end

  specify 'should have the correct values' do
    @user.claimed_id.should eq('http://www.google.com')
    @user.nickname.should eq('voidmain')
    @user.email.should eq('voidmain1313113@gmail.com')
  end
end
