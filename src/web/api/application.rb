require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require File.join(File.dirname(__FILE__), 'environment')

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
end

error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  'Application error'
end

helpers do
  # add your helpers here
end

# APIs v1
# User APIs

# for single user
# get user info
get '/v1/user/:id' do
end

# update user info
put '/v1/user/:id' do
end

# delete user
delete '/v1/user/:id' do
end

# insert new user
put '/v1/user'
end

# get all registered users
get '/v1/users' do
end

# Team APIs
# get a specific team
get '/v1/team/:id' do
end

# update a team's info
put '/v1/team/:id' do
end

# delete a team
delete '/v1/team/:id' do
end

# create a new team
put '/v1/team' do
end

# get all teams
get '/v1/teams' do
end

# TeamAdmin APIs
# get all team members for a specfic team
get '/v1/team/:id/members' do
end

# get all teams a user joined
get '/v1/user/:id/teams' do
end

# get the role of a user in some team
get '/v1/team/:team_id/member/:user_id/role' do
end

# get the status of a user in some team
get '/v1/team/:team_id/member/:user_id/status' do
end

# insert / update the role of a user in some team
# arguments:
#     value - integer, the value of the role [REQUIRED]
# PUT /v1/team/1/member/2/role?value=1
put '/v1/team/:team_id/member/:user_id/role' do
end

# insert / update the status of a user in some team
# arguments:
#     value - integer, the value of the status [REQUIRED]
# PUT /v1/team/1/member/2/status?value=2
put '/v1/team/:team_id/member/:user_id/status' do
end

# remove a member from a team
delete '/v1/team/:team_id/member/:user_id' do
end

# Marks APIs
# get the list of marks for a team, grouped by user
# prepared for paperboy
# arguments:
#     later_than - integer [OPTIONAL]
# GET /v1/marks/team/2?later_than=20
get '/v1/marks/team/:team_id' do
end

# get the list of marks shared by a user to a team
# arguments:
#     later_than - integer [OPTIONAL]
# GET /v1/marks/team/2/user/1?later_than=20
get '/v1/marks/team/:team_id/user/:user_id' do
end

# get a list of marks, by some filters
# arguments:
#     filter arguments, like channel, user_id, team_id
#     later_than - integer [OPTIONAL]
# GET /v1/marks?later_than=20&channel=1
get '/v1/marks' do
end

# share a new mark
put '/v1/mark' do
end

# update a mark content (not quite useful)
put '/v1/mark/:id' do
end

# delete a mark
delete '/v1/mark/:id' do
end

# Invitation APIs
# get a new valid code
# arguments:
#     valid - true / false [OPTIONAL]
# GET /v1/invitation-code?valid=false
get '/v1/invitation-code' do
end

# get the info for a specific code
# GET /v1/invitation-code/1
get '/v1/invitation-code/:id' do
end

# update the code info
put '/v1/invitation-code/:id' do
end

# get a bunch of invitation codes
# arguments
#     num - integer [OPTIONAL, default to 1]
# GET /v1/invitation-codes?num=5
get '/v1/invitation-codes' do
end
