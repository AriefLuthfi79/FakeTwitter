class SessionsController < ApplicationController
  def new
    
  end

  def create
    user = User.find_by(email: resource_params_email)
    if user && user.authenticate(resource_params_password)
      log_in(user)
      redirect_to user
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy 
    log_out
    redirect_to root_url
  end

  private
  
  def resource_params_email
    params_email = params.require(:session).permit(:email)
    return false if params_email.nil?
    return params_email[:email]
  end

  def resource_params_password
    params_password = params.require(:session).permit(:password)
    return false if params_password.nil?
    return params_password[:password]
  end
end
