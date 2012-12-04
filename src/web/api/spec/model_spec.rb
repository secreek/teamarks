require_relative "spec_helper"

describe 'user' do
  before(:each) do
    @user = User.new(claimed_id: 'http://www.google.com',
      nickname: 'voidmain',
      email: 'voidmain1313113@gmail.com')
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

describe 'Team' do
  before(:each) do
    @team = Team.new(name: 'GoF',
      description: 'Gay of Four',
      mailinglist: 'gof@gmail.com')
    @team.save
  end

  specify 'should have the correct values' do
    @team.name.should eq('GoF')
    @team.description.should eq('Gay of Four')
    @team.mailinglist.should eq('gof@gmail.com')
  end
end


describe 'InvitationCode' do
  before(:each) do
    @ic = InvitationCode.new(code: '123',
      still_valid: true)
    @ic.save
  end

  specify 'should have the correct values' do
    @ic.code.should eq('123')
    @ic.still_valid.should eq(true)
    @ic.taken
    @ic.still_valid.should eq(false)
  end
end

describe 'TeamAdmin' do
  before(:each) do
    # Let's build 2 teams
    @team1 = Team.new(name: 'Team 1',
      description: 'No.1 Team',
      mailinglist: 'team1@gmail.com')
    @team1.save
    @team2 = Team.new(name: 'Team 2',
      description: 'No.2 Team',
      mailinglist: 'team2@gmail.com')
    @team2.save

    # Say there are 4 registered users
    @user1 = User.new(claimed_id: 'http://www.google.com/1',
      nickname: 'user1',
      email: 'user1@gmail.com')
    @user1.save
    @user2 = User.new(claimed_id: 'http://www.google.com/2',
      nickname: 'user2',
      email: 'user2@gmail.com')
    @user2.save
    @user3 = User.new(claimed_id: 'http://www.google.com/3',
      nickname: 'user3',
      email: 'user3@gmail.com')
    @user3.save
    @user4 = User.new(claimed_id: 'http://www.google.com/4',
      nickname: 'user4',
      email: 'user4@gmail.com')
    @user4.save

    # User1 joins Team 1
    # User2 joins Team 1
    # User3 joins Team 2
    # User4 joins Team 1 & Team 2
    @add_user_to_team = TeamMember.new(role: '0',
      status: '0')
    @add_user_to_team.user = @user1
    @add_user_to_team.team = @team1
    @add_user_to_team.save

    @add_user_to_team = TeamMember.new(role: '0',
      status: '0')
    @add_user_to_team.user = @user2
    @add_user_to_team.team = @team1
    @add_user_to_team.save

    @add_user_to_team = TeamMember.new(role: '0',
      status: '0')
    @add_user_to_team.user = @user3
    @add_user_to_team.team = @team2
    @add_user_to_team.save

    @add_user_to_team = TeamMember.new(role: '0',
      status: '0')
    @add_user_to_team.user = @user4
    @add_user_to_team.team = @team1
    @add_user_to_team.save

    @add_user_to_team = TeamMember.new(role: '0',
      status: '0')
    @add_user_to_team.user = @user4
    @add_user_to_team.team = @team2
    @add_user_to_team.save
  end

  specify 'should have the correct values' do
    TeamMember.count(:team => @team1).should eq(3)
    TeamMember.count(:team => @team2).should eq(2)
    TeamMember.count(:user => @user1).should eq(1)
    TeamMember.count(:user => @user2).should eq(1)
    TeamMember.count(:user => @user3).should eq(1)
    TeamMember.count(:user => @user4).should eq(2)
    TeamMember.count(:team => @team1, :user => @user1).should eq(1)
    TeamMember.count(:team => @team1, :user => @user3).should eq(0)
  end
end

