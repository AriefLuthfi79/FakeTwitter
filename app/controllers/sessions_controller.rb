class SessionsController < ApplicationController
  def new
    
  end

  def create
    @user = User.find_by(email: resource_params_email)
    if @user && @user.authenticate(resource_params_password)
      if @user.activated?
        log_in @user
        forget_or_remember(@user)
        redirect_back_or @user
      else
        message = "Account not activated. "
        message += "Check your email for the activation link"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
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

  # Returns remember method if checkbox remember me is checked and will return forget otherwise
  def forget_or_remember(user)
    return params[:session][:remember_me] == '1' ? remember(user) : forget(user)
  end
end
