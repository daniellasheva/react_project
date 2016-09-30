class ApplicationController < ActionController::API

  before_action :authenticate

  def logged_in?
    !!current_user  #will return true if current_user is not a falsey value
  end

  def current_user
    if auth_present?
      user= User.find(auth["user"])
      if user
        @current_user ||=user
      end
    end
  end

  def authenticate
    render json: {error: "unauthorized"}, status: 404
      unless logged_in?
  end

  private

  def token #grabbing the pieces we want from the request.env object
    request.env["HTTP_AUTHORIZATION"].scan(/Bearer(.*)$/).flatten.last
  end

  def auth_present? #checking if our request object has a header or a key
    !!request.env.fetch("HTTP_AUTHORIZATION", "").scan(/Bearer/).flatten.first
  end

  def auth
    #We have an id key inside the token that we decode
    Auth.decode(token)
  end

end
