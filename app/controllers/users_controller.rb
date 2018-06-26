class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :edit_password]
  before_action :correct_user,   only: [:edit, :update, :edit_password]
  before_action :guest,          only: [:new]
  before_action :admin_user,     only: [:index, :show, :edit, :update,
                                        :destroy]

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated
  end

  def new
    not_found
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = msg(:info_acc_reg)
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    if @user.is_admin? && current_user.is_admin?
      render 'edit_admin'
    else
      render 'edit'
    end
  end

  def edit_password
    @user = User.find(params[:id])
    render 'edit_password'
  end

  def update
    if @user.is_admin? && current_user.is_admin?
      if @user.update_attributes(admin_params)
        @user.bio = markup params[:user][:bio_draft]
        @user.save
        flash[:success] = msg(:succ_user_update)
        redirect_to @user
      else
        render 'edit_admin'
      end
    else
      if @user.update_attributes(user_params_edit)
        flash[:success] = msg(:succ_user_update)
        redirect_to @user
      else
        render 'edit'
      end
    end
  end

  def update_password
    @user = User.find(params[:id])
    if @user.authenticate(params[:user][:current_password])
      if @user.update_attributes(pswd_params_b)
        flash[:success] = msg(:succ_user_update)
        redirect_to @user
      else
        render 'edit_password'
      end
    else
      @user.errors.add(:current_password, "is not valid")
      render 'edit_password'
    end
  end

  def destroy
    user = User.find(params[:id])
    id = user.id
    name = user.name
    user.destroy
    flash[:success] = msg(:succ_user_delete, id, name)
    redirect_to users_url
  end

  private
    
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    def user_params_edit
      params.require(:user).permit(:name, :email)
    end

    def admin_params
      params.require(:user).permit(:name, :email, :about, :avatar,
                                   :avatar_cache, :remove_avatar,
                                   :tweet_posts, :blog_post_toot_visibility,
                                   :theme, :meta_keywords, :meta_desc,
                                   :site_name, :site_slogan, :forum_url,
                                   :comment_flag, :blog_spam_flag,
                                   :site_icon, :site_icon_cache,
                                   :remove_site_icon, :site_banner,
                                   :site_banner_cache, :remove_site_banner,
                                   :bio_draft, :skin)
    end

    def pswd_params_b
      params.require(:user).permit(:password, :password_confirmation)
    end


end
