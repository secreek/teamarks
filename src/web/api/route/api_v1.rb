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

  # WARNING: Duplicate Code HERE!!
  # TODO compress these codes
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
  end

  # get all teams a user joined
  get '/users/:id/teams' do
  end

  # create the relationship with a user and a team
  post '/teams/:team_id/members/:user_id' do
  end

  # get the role of a user in some team
  get '/teams/:team_id/members/:user_id/role' do
  end

  # get the status of a user in some team
  get '/teams/:team_id/members/:user_id/status' do
  end

  # update the role of a user in some team
  # arguments:
  #     value - integer, the value of the role [REQUIRED]
  # PUT /v1/teams/1/members/2/role?value=1
  put '/teams/:team_id/members/:user_id/role' do
  end

  # update the status of a user in some team
  # arguments:
  #     value - integer, the value of the status [REQUIRED]
  # PUT /v1/teams/1/members/2/status?value=2
  put '/teams/:team_id/members/:user_id/status' do
  end

  # remove a member from a team
  delete '/teams/:team_id/members/:user_id' do
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
  post '/marks' do
  end

  # Invitation APIs
  # get a bunch of invitation codes
  # arguments
  #     valid - true / false [OPTIONAL, default to true]
  #     num - integer [OPTIONAL, default to 1]
  # GET /v1/invitation-codes?num=5&valid=true
  get '/invitation-codes' do
  end

  # get the info for a specific code
  # GET /v1/invitation-codes/1
  get '/invitation-codes/:id' do
  end

  # create a new code
  post '/invitation-codes' do
  end

  # update the code info
  put '/invitation-codes/:id' do
  end

  # delete the code info
  delete '/invitation-codes/:id' do
  end
end
