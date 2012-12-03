require_relative "spec_helper"

describe 'user' do
  before(:each) do
    @user = User.new(claimed_id: 'http://www.google.com',
      nickname: 'voidmain',
      email: 'voidmain1313113@gmail.com',
      created_at: Time.now,
      updated_at: Time.now)
    @user.save
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

describe 'InvitationCode' do
  before(:each) do
    @ic = InvitationCode.new(code: '123',
      still_valid: true,
      created_at: Time.now)
    @ic.save
  end

  specify 'should have the correct values' do
    @ic.code.should eq('123')
    @ic.still_valid.should eq(true)
    @ic.taken
    @ic.still_valid.should eq(false)
  end
end

