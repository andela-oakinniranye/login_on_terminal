gem 'sinatra'
gem 'sinatra-contrib'
gem 'thin'

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pry'

register Sinatra::Reloader

get '/' do
  "Hello Oreoluwa"
end

get '/login' do
  email = params["email"]
  password = params["password"]
  return General.reload.authenticated(email, password)
end

get '/authenticate' do
  token = params["token"]
  General.reload.add_token(token) if token
end

get '/validate/:token' do
  token = params[:token]
  General.reload.auth_with_token(token)
end

get '/auth/:tok' do
  token = params[:tok]
  General.reload.authed(token)
end

get '/register' do
  email = params[:email]
  password = params[:password]
  General.reload.register(email, password) if email && password
end

before do
  puts params
end

class General
  @@total_times_connected = 0
  @@users = Hash.new(nil)
  @@token = {}
  # @@queue = Hash.new(nil)
  @@authenticate_message = "You have been authenticated"
  @@try_again_message = "You may try again"

  # def self.perform(method_name, *args, &block)
  #   EM.run do
  #     EM.add_timer(4) do
  #       General.send(method_name, args, &block)
  #       EM.stop
  #     end
  #   end
  # end

  def self.register(email, password)
    @@users[email] = password
    scrambled_password = ('*' * password.length)
    scrambled_password[-1] = password[-1]
    "Congratulations #{email} you were successfully registered.\n Your password ends with #{scrambled_password}"
  end

  def self.reload
    increment_total
    self
  end

  def self.auth(email: nil, password: nil)
    user = @@users[email]
    true if user
  end

  def self.authenticated(email=nil, password=nil)
    auth_n = true if auth(email: email, password: password)
    message = auth_n ? @@authenticate_message : @@try_again_message
    return {authenticated: auth_n, message: message, total: @@total_times_connected}.to_json
  end

  def self.increment_total
    @@total_times_connected += 1
  end

  def self.add_token(tok)
    @@token[tok] = false
  end

  def self.auth_with_token(tok)
    @@token[tok] = true if @@token.keys.include? tok
    self
  end

  def self.authed(tok)
    return {message: "Congratulations, confirmed", total: @@total_times_connected, authenticated: true}.to_json if @@token[tok] == true
    return {message: "Not confirmed", total: @@total_times_connected, authenticated: false}.to_json unless @@token[tok] == true
  end

end

class Queue
  @@queue = Array.new

  # def initialize
  #
  # end

  def self.execute
    executed = []
    @@queue.each_with_index{ |val, ind|
      # @@queue.delete_at(ind)
      # actions = val
      # actions[:method]
      # General.send()
      executed << ind
    }

    # executed.each{|i|
    #   @@queue.delete_at(i)
    # }
  end

  def self.enqueue(actions)
    @@queue << actions
  end

  def self.dequeue

    # @@queue.
  end
end

    # if USERS.keys.include? email
    # true if email == EMAIL && password == PASSWORD

    # @@users = Hash.new(nil)
    # puts @@users
  # binding.pry
  # EMAIL = 'oreoluwa@outlook.com'
  # PASSWORD = 'oreoluwa'


# def authenticated
#   "You have been authenticated"
# end
#
# def try_again
#   "You may try again"
# end



# total = General.increment_total
# return General.authenticated(try_again) if total < 5


# auth = @@total_times_connected >= 5 ? true : false
# @@total_times_connected = 0



  # def authenticate_message
  #   "You have been authenticated"
  # end
  #
  # def try_again_message
  #   "You may try again"
  # end


# get '/a'
# if total >= 5
# return "#{General.authenticated(try_again)}: #{total}"
#  unless total > 5


# def decrement_total
#
# end
