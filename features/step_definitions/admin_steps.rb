require 'rack/test'
include Rack::Test::Methods

Given /^I have access to the admin panel$/ do
  test_user = User.new
  test_user.username='foo'
  test_user.password='foo'
  test_user.full_name = "foo bar"
  test_user.save
  authorize 'foo', 'foo'
end

When /^I add the user from the admin panel$/ do
  @user = "jobob"
  @pass = "pass123"
  post '/users/add', {:username=>@user, :pass=>@pass, :full_name=>"full name"}
end

Then /^they will show up in the list of directors$/ do
  get '/users'
  @user_obj = User.all(:username => @user)[0]
  last_response.body.include?(@user_obj.id.to_s).should == true
end

Then /^be able to log in themselves$/ do
  authorize @user, @pass
  get '/users'
  last_response.status.should eq 200
end

Given /^The hacker does not have an account$/ do
  User.all(:username=>'hacker').count.should eq 0
end

When /^he tries to access \/users\/$/ do
  authorize 'hacker', 'hackme'
  get '/users'
end

Then /^he will be denied$/ do
  last_response.status.should eq 401
end

