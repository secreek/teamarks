require 'sinatra'
require 'sinatra/namespace'
require 'data_mapper'
require './model/model.rb'
require './helper/http_helper.rb'
require 'json'

# APIs v1 - User
namespace '/v1' do
  # User APIs
  # for single user
  # get user info
  get '/users/:id' do
    begin
      user = User.get!(params[:id])
      Response.new(200, user).to_json
    rescue DataMapper::ObjectNotFoundError
      Response.new(404, 'User not found').to_json
    end
  end

  # update user info
  put '/users/:id' do
    begin
      user = User.get!(params[:id])
      user.update(User.normalize_params(params))
      Response.new(200, user).to_json
    rescue DataMapper::ObjectNotFoundError
      Response.new(404, 'User not found').to_json
    rescue DataMapper::SaveFailureError
      Response.new(500, 'User not inserted').to_json
    rescue DataMapper::UpdateConflictError
      Response.new(409, 'Update Conflict').to_json
    end
  end

  # delete user
  delete '/users/:id' do
    begin
      User.get!(params[:id]).destroy
      Response.new(200, 'Deleted').to_json
    rescue DataMapper::ObjectNotFoundError
      Response.new(404, 'User not found').to_json
    end
  end

  # test if the unique attributes has been taken
  # arguments:
  #     name - name of the attribute
  #     value - value of the attribute
  # return value:
  #     1 if the attribute is unique and the value has been taken
  #     0 otherwise
  get '/users/attrs/is_unique' do
    name = params["name"]
    value = params["value"]
    return Response.new(200, 0).to_json if !User.is_unique_attribute? name
    result = (User.count(name => value) == 0)
    return Response.new(200, result ? 1 : 0).to_json
  end

  # insert new user
  post '/users' do
    begin
      user = User.new(User.normalize_params(params))
      user.save
      Response.new(200, user).to_json
    rescue DataMapper::SaveFailureError
      Response.new(500, 'User not inserted').to_json
    end
  end

  # get all registered users
  get '/users' do
    result = []
    User.all.to_a.each do |user|
      result << user.to_json_obj
    end
    Response.new(200, result).to_json
  end

  # Team APIs
  # get a specific team
  get '/teams/:id' do
    begin
      team = Team.get!(params[:id])
      Response.new(200, team).to_json
    rescue DataMapper::ObjectNotFoundError
      Response.new(404, 'Team not found').to_json
    end
  end

  # update a team's info
  put '/teams/:id' do
    begin
      team = Team.get!(params[:id])
      team.update(Team.normalize_params(params))
      Response.new(200, team).to_json
    rescue DataMapper::ObjectNotFoundError
      Response.new(404, 'Team not found').to_json
    rescue DataMapper::SaveFailureError
      Response.new(500, 'Team not inserted').to_json
    rescue DataMapper::UpdateConflictError
      Response.new(409, 'Update Conflict').to_json
    end
  end

  # delete a team
  delete '/teams/:id' do
    begin
      Team.get!(params[:id]).destroy
      Response.new(200, 'Deleted').to_json
    rescue DataMapper::ObjectNotFoundError
      Response.new(404, 'Team not found').to_json
    end
  end

  # test if the unique attributes has been taken
  # arguments:
  #     name - name of the attribute
  #     value - value of the attribute
  # return value:
  #     1 if the attribute is unique and the value has been taken
  #     0 otherwise
  get '/teams/attrs/is_unique' do
    name = params["name"]
    value = params["value"]
    return Response.new(200, 0).to_json if !Team.is_unique_attribute? name
    result = (Team.count(name => value) == 0)
    return Response.new(200, result ? 1 : 0).to_json
  end

  # create a new team
  post '/teams' do
    begin
      team = Team.new(Team.normalize_params(params))
      team.save
      Response.new(200, team).to_json
    rescue DataMapper::SaveFailureError
      Response.new(500, 'Team not inserted').to_json
    end
  end

  # get all teams
  get '/teams' do
    result = []
    Team.all.to_a.each do |team|
      result << team.to_json_obj
    end
    Response.new(200, result).to_json
  end

  # TeamAdmin APIs
  # get all team members for a specfic team
  get '/teams/:id/members' do
    begin
      result = {}
      team = Team.get!(params[:id])
      result['team'] = team
      members = []
      TeamMember.all('team' => team).to_a.each do |relation|
        members << relation.user.to_json_obj
      end
      result['members'] = members
      Response.new(200, result).to_json
    rescue DataMapper::ObjectNotFoundError
      Response.new(404, 'Team not found').to_json
    end
  end

  # get all teams a user joined
  get '/users/:id/teams' do
    begin
      result = {}
      user = User.get!(params[:id])
      result['user'] = user
      teams = []
      TeamMember.all('user' => user).to_a.each do |relation|
        teams << relation.team.to_json_obj
      end
      result['teams'] = teams
      Response.new(200, result).to_json
    rescue DataMapper::ObjectNotFoundError
      Response.new(404, 'User not found').to_json
    end
  end

  def team_and_user_parser params
    user = User.get(params[:user_id])
    team = Team.get(params[:team_id])

    [team, user]
  end

  # create the relationship with a user and a team
  post '/teams/:team_id/members/:user_id' do
    team, user = team_and_user_parser(params)
    return Response.new(404, 'User not found').to_json unless user
    return Response.new(404, 'Team not found').to_json unless team

    begin
      params['team'] = team
      params['user'] = user
      relation = TeamMember.new(TeamMember.normalize_params(params))
      relation.save
      Response.new(200, relation).to_json
    rescue DataMapper::SaveFailureError
      Response.new(500, 'relationship not inserted').to_json
    end
  end

  # get the infomation of a relationship between a user and a team
  get '/teams/:team_id/members/:user_id' do
    team, user = team_and_user_parser(params)
    return Response.new(404, 'User not found').to_json unless user
    return Response.new(404, 'Team not found').to_json unless team

    relation = TeamMember.all('team' => team, 'user' => user)
    return Response.new(404, 'Relationship not found').to_json if relation.count == 0
    Response.new(200, relation[0]).to_json
  end

  # update the values of a relationship between a team and a user
  put '/teams/:team_id/members/:user_id' do
    team, user = team_and_user_parser(params)
    return Response.new(404, 'User not found').to_json unless user
    return Response.new(404, 'Team not found').to_json unless team

    begin
      relation = TeamMember.all('team' => team, 'user' => user)
      return Response.new(404, 'Relationship not found').to_json if relation.count == 0
      relation[0].update(TeamMember.normalize_params(params))
      Response.new(200, relation).to_json
    rescue DataMapper::SaveFailureError
      Response.new(500, 'Relationship not inserted').to_json
    rescue DataMapper::UpdateConflictError
      Response.new(409, 'Update Conflict').to_json
    end
  end

  # remove a member from a team
  delete '/teams/:team_id/members/:user_id' do
    team, user = team_and_user_parser(params)
    return Response.new(404, 'User not found').to_json unless user
    return Response.new(404, 'Team not found').to_json unless team

    relation = TeamMember.all('team' => team, 'user' => user)
    return Response.new(404, 'Relationship not found').to_json if relation.count == 0
    relation[0].destroy
    Response.new(200, 'Deleted').to_json
  end

  # Marks APIs
  # get the list of marks for a team, grouped by user
  # prepared for paperboy
  # arguments:
  #     later_than - integer [OPTIONAL]
  # GET /v1/marks/teams/2?later_than=20
  get '/marks/teams/:team_id' do
  end

  # get the list of marks shared by a user to a team
  # arguments:
  #     later_than - integer [OPTIONAL]
  # GET /v1/marks/teams/2/users/1?later_than=20
  get '/marks/teams/:team_id/users/:user_id' do
  end

  # get a list of marks, by some filters
  # arguments:
  #     filter arguments, like channel, user_id, team_id
  #     later_than - integer [OPTIONAL]
  # GET /v1/marks?later_than=20&channel=1
  get '/marks' do
  end

  # share a new mark
  # required arguments:
  #     teams - comma seperated number list
  #     url   - url of the page
  #     title
  #     description
  #     channel - where the mark is shared
  post '/marks/user/:user_id' do
    user = User.get(params[:user_id])
    return Response.new(404, 'User not found') unless user
    params['user'] = user

    result = []
    teams = params[:teams].split(/\s*,\s*/)
    teams.each do |team_id|
      team = Team.get(team_id)
      if team and TeamAdmin.count('user' => user, 'team' => team) > 0
        params['team'] = team
        mark = Mark.new(params)
        mark.save
        result << mark
      else
        result << "Team #{team_id} not found"
      end
    end
  end

  # Invitation APIs
  # get a bunch of invitation codes
  # arguments
  #     valid - true / false [OPTIONAL, default to true]
  #     num - integer [OPTIONAL, default to 1]
  # GET /v1/invitation-codes?num=5&valid=true
  get '/invitation-codes' do
    result = []

    still_valid = true # defaults to true
    still_valid = false if params['valid'] == 'false'
    num = params['num'].to_i
    num -= 1 unless num == 0

    all_codes = InvitationCode.all('still_valid' => still_valid).to_a
    sub_codes = all_codes.shuffle[0..num]

    sub_codes.each do |team|
      result << team.to_json_obj
    end
    Response.new(200, result).to_json
  end

  # get the info for a specific code
  # GET /v1/invitation-codes/1
  get '/invitation-codes/:id' do
    begin
      code = InvitationCode.get!(params[:id])
      Response.new(200, code).to_json
    rescue DataMapper::ObjectNotFoundError
      Response.new(404, 'Invitation code not found').to_json
    end
  end

  # create a new code
  post '/invitation-codes' do
    begin
      code = InvitationCode.new(InvitationCode.normalize_params(params))
      code.save
      Response.new(200, code).to_json
    rescue DataMapper::SaveFailureError
      Response.new(500, 'Invitation code not inserted').to_json
    end
  end

  # used a invitation code
  post '/invitation-codes/:id/used' do
    begin
      code = InvitationCode.get!(params[:id])
      code.taken
      Response.new(200, 'Invitation code used').to_json
    rescue DataMapper::ObjectNotFoundError
      Response.new(404, 'Invitation code not found').to_json
    rescue DataMapper::UpdateConflictError
      Response.new(409, 'Update Conflict').to_json
    end
  end

  # update the code info
  put '/invitation-codes/:id' do
    begin
      code = InvitationCode.get!(params[:id])
      code.update(InvitationCode.normalize_params(params))
      Response.new(200, code).to_json
    rescue DataMapper::ObjectNotFoundError
      Response.new(404, 'Invitation code not found').to_json
    rescue DataMapper::SaveFailureError
      Response.new(500, 'Invitation code not inserted').to_json
    rescue DataMapper::UpdateConflictError
      Response.new(409, 'Update Conflict').to_json
    end
  end

  # delete the code info
  delete '/invitation-codes/:id' do
    begin
      InvitationCode.get!(params[:id]).destroy
      Response.new(200, 'Deleted').to_json
    rescue DataMapper::ObjectNotFoundError
      Response.new(404, 'Invitation code not found').to_json
    end
  end
end
