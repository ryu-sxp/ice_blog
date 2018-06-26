class SessionsController < ApplicationController
  before_action :guest, only: [:new]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.is_activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = msg(:warning_account_not_active)
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid credentials'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

    def guest
      if logged_in?
        flash[:info] = msg(:info_logout_required)
        redirect_to root_url
      end
    end

end
