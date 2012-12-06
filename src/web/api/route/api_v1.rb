require 'sinatra'
# APIs v1

# User APIs
# for single user
# get user info
get '/v1/users/:id' do
  puts "Got #{params[:id]}"
end

# update user info
put '/v1/users/:id' do
end

# delete user
delete '/v1/users/:id' do
end

# insert new user
post '/v1/users' do
end

# get all registered users
get '/v1/users' do
end

# Team APIs
# get a specific team
get '/v1/teams/:id' do
end

# update a team's info
put '/v1/teams/:id' do
end

# delete a team
delete '/v1/teams/:id' do
end

# create a new team
post '/v1/teams' do
end

# get all teams
get '/v1/teams' do
end

# TeamAdmin APIs
# get all team members for a specfic team
get '/v1/teams/:id/members' do
end

# get all teams a user joined
get '/v1/users/:id/teams' do
end

# get the role of a user in some team
get '/v1/teams/:team_id/members/:user_id/role' do
end

# get the status of a user in some team
get '/v1/teams/:team_id/members/:user_id/status' do
end

# insert / update the role of a user in some team
# arguments:
#     value - integer, the value of the role [REQUIRED]
# PUT /v1/teams/1/members/2/role?value=1
put '/v1/teams/:team_id/members/:user_id/role' do
end

# insert / update the status of a user in some team
# arguments:
#     value - integer, the value of the status [REQUIRED]
# PUT /v1/teams/1/members/2/status?value=2
put '/v1/teams/:team_id/members/:user_id/status' do
end

# remove a member from a team
delete '/v1/teams/:team_id/members/:user_id' do
end

# Marks APIs
# get the list of marks for a team, grouped by user
# prepared for paperboy
# arguments:
#     later_than - integer [OPTIONAL]
# GET /v1/marks/teams/2?later_than=20
get '/v1/marks/teams/:team_id' do
end

# get the list of marks shared by a user to a team
# arguments:
#     later_than - integer [OPTIONAL]
# GET /v1/marks/teams/2/users/1?later_than=20
get '/v1/marks/teams/:team_id/users/:user_id' do
end

# get a list of marks, by some filters
# arguments:
#     filter arguments, like channel, user_id, team_id
#     later_than - integer [OPTIONAL]
# GET /v1/marks?later_than=20&channel=1
get '/v1/marks' do
end

# share a new mark
post '/v1/marks' do
end

# Invitation APIs
# get a bunch of invitation codes
# arguments
#     valid - true / false [OPTIONAL, default to true]
#     num - integer [OPTIONAL, default to 1]
# GET /v1/invitation-codes?num=5&valid=true
get '/v1/invitation-codes' do
end

# get the info for a specific code
# GET /v1/invitation-codes/1
get '/v1/invitation-codes/:id' do
end

# create a new code
post '/v1/invitation-codes' do
end

# update the code info
put '/v1/invitation-codes/:id' do
end

# delete the code info
delete '/v1/invitation-codes/:id' do
end
