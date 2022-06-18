class SessionsController < ApplicationController
  def new
    # rendering login form view
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password]) # authenticate method provided by has_secure_password
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        # ternary operator for checkbox (remember_user in sessions_helper)
        redirect_back_or user
      else
        flash.now[:danger] = 'Invalid email/password combination'
        render 'new'
      end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
