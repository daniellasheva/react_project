class SessionsController < ApplicationController

  skip_before_action :authenticate

  def create
    user= User.find(id: auth_params[:id])
    if user.authenticate(auth_params[:password])
      token= Auth.issue({id: user.id})
      render json: {jwt: token}
    else
      render json: {error: "You're not authorized!"}, status: 401
    end
  end

  private

  def auth_params
    params.require(:auth).permit(:email, :password)
  end

end
