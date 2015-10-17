gem 'faraday'

require 'faraday'
require 'json'
require 'securerandom'

class Custom
  attr_reader :connection, :token
  URL = 'http://localhost:4567'

  def initialize
     connect
  end

  def connect
    @connection = Faraday::Connection.new(URL)
  end

  def register_user
    puts "Hi you want to register for this crappy app? Enter your email: "
    email = gets.chomp
    puts "Enter your password (this would be hidden from prying eyes)"
    password = STDIN.noecho{ gets.chomp }
    response = connection.get('/register', {email: email ,password: password })
    response.body
  end

  def login_user_process
    login_process
    send_token
    puts "Go to this URL to validate yourself: #{URL}/validate/#{@token}"
    wait_for_auth
  end


  def login_process
    begin
      @login_response = login
    end until @login_response["authenticated"]
  end

  def login
    puts "Hi you want to login? Enter your email: "
    email = gets.chomp
    puts "Enter your password(would be hidden)"
    password = STDIN.noecho{ gets.chomp }
    login_url(email, password)
  end

  def generate_code
    @token = SecureRandom.uuid.gsub(/\-/, '')
  end

  def wait_for_auth
    begin
      sleep 6
      @real_user = authenticate
      auth__ = @real_user["authenticated"]
    end until auth__
    puts "I completed successfully"
  end

  def login_url(email, password)
    response = connection.get('/login', {email: email, password: password })
    JSON.parse response.body
  end

  def send_token
    generate_code
    response = connection.get('/authenticate', {token: @token})
    response.body
  end

  def authenticate
    response = connection.get("/auth/#{token}")
    JSON.parse(response.body)
  end
end


# cu = Custom.new
# cu.login_user_process

  # @@url =
# puts @real_user

  #
  # def authenticated
  #
  # end


    # until authenticate["authenticated"] == true
    #   authenticate
    #   # connection.get()
    # end
